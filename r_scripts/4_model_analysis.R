# Analysis of tuned and trained models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/student_train.rda"))

# load trained models
load(here("results/fit_null.rda"))
load(here("results/fit_baseline.rda"))
load(here("results/fit_log.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/fit_nbayes.rda"))

# inspecting model fit 
fit_log |> 
  tidy()

# failed bc i used logistic regression which models binary outcomes
# fit_baseline |>  collect_metrics()
# fit_log |> collect_metrics()

# looking at accuracy of models
acc_table <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "Null") |> 
  select(-n, -.config, -.estimator) |> 
  bind_rows(
    nbayes_fit |> 
  collect_metrics() |> 
  mutate(model = "Naive Bayes") |> 
  select(-n, -.config, -.estimator) 
  ) |> bind_rows(
tuned_rf |> 
  show_best("accuracy") |> 
  slice_min(mean) |> 
  select(mean, std_err, .metric) |> 
  mutate(model = "Random Forest")
) |>
  filter(.metric == "accuracy") |> 
  arrange(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         `STD Error` = std_err)

# looking at roc_auc
roc_auc_tbl <- tuned_rf |> 
  show_best("roc_auc") |> 
  slice_min(mean) |> 
  select(mean, std_err, .metric) |> 
  mutate(model = "Random Forest") |> 
  bind_rows(
    nbayes_fit |> 
      collect_metrics() |>
      mutate(model = "Naive Bayes") |> 
      select(-n, -.config, -.estimator)
    ) |> 
  bind_rows(null_fit |> 
              collect_metrics() |>
              mutate(model = "Null") |> 
              select(-n, -.config, -.estimator)
            ) |> 
  filter(.metric == "roc_auc") |> 
  arrange(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         roc_auc,
         `STD Error` = std_err)

acc_table |> knitr::kable()
roc_auc_tbl |> knitr::kable()


# extract predictions 
pred_data_log <- predict(fit_log, student_train) 

pred_baseline <- predict(fit_baseline, student_train) 

best_rf_model <- select_best(tuned_rf, "roc_auc")

# match predictions to outcome values 
log_preds <- bind_cols(pred_data_log, student_train) |> 
  select(.pred_class, target)

baseline_preds <- bind_cols(pred_baseline, student_train) |>
  select(.pred_class, target)

# create a metric set 
student_metrics <- metric_set(roc_auc, pr_auc, accuracy)

accuracy_log <- accuracy(log_preds, truth = target, estimate = .pred_class)|> 
  select(.estimate) |> 
  rename(Accuracy = .estimate) |> 
  mutate(Model = "Logistic Regression")

accuracy <- bind_rows(
     accuracy(log_preds, truth = target, estimate = .pred_class)|> 
       select(.estimate) |> 
       rename(Accuracy = .estimate) |> 
       mutate(Model = "Logistic Regression"),
   
     accuracy(baseline_preds, truth = target, estimate = .pred_class)|> 
       select(.estimate) |> 
       rename(Accuracy = .estimate) |> 
       mutate(Model = "Baseline Log")
   )

# create tibble 
write_csv(accuracy_log, here("figures/accuracy_log.csv"))
write_csv(accuracy, here("figures/accuracy.csv"))
