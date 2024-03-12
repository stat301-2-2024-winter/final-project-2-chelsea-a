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
load(here("results/fit_multinom.rda"))
load(here("results/fit_multinom_2.rda"))
load(here("results/fit_multinom_3.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/fit_nbayes.rda"))
load(here("results/tuned_en.rda"))

# look at multinomial models metrics
fit_multinom |> 
  collect_metrics() |> 
  mutate(model = "mn 1") |> 
  bind_rows(
    fit_multinom_2 |>
      collect_metrics() |> 
      mutate(model = "mn 2") 
    )|> 
  bind_rows(
    fit_multinom_3 |>
      collect_metrics() |> 
      mutate(model = "mn 3")
  ) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         roc_auc,
         `STD Error` = std_err)

# mn 1 performed the best

# looking at accuracy of models
acc_table <- null_fit |> 
  collect_metrics() |> 
  mutate(model = "Null") |> 
  select(-n, -.config, -.estimator) |> 
  bind_rows(
    fit_nbayes |>
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
  bind_rows(
    fit_multinom |>
      collect_metrics() |> 
      mutate(model = "Multinomial") |> 
      select(-n, -.config, -.estimator)
    ) |> bind_rows(
      tuned_en |> 
        show_best("accuracy") |> 
        slice_min(mean) |> 
        select(mean, std_err, .metric) |> 
        mutate(model = "Elastic Net")
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
    fit_nbayes |> 
      collect_metrics() |>
      mutate(model = "Naive Bayes") |> 
      select(-n, -.config, -.estimator)
    ) |> 
  bind_rows(
    null_fit |> 
      collect_metrics() |>
      mutate(model = "Null") |> 
      select(-n, -.config, -.estimator)
    ) |> 
  bind_rows(
    fit_multinom |>
      collect_metrics() |> 
      mutate(model = "Multinomial") |> 
      select(-n, -.config, -.estimator)
    ) |>
  bind_rows(
      tuned_en |> 
        show_best("roc_auc") |> 
        slice_min(mean) |> 
        select(mean, std_err, .metric) |> 
        mutate(model = "Elastic Net")
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


# pred_baseline <- predict(fit_nbayes, student_train) 
# 
# best_rf_model <- select_best(tuned_rf, "roc_auc")

# match predictions to outcome values 
# log_preds <- bind_cols(pred_data_log, student_train) |> 
#   select(.pred_class, target)
# 
# baseline_preds <- bind_cols(pred_baseline, student_train) |>
#   select(.pred_class, target)

# # create a metric set 
# student_metrics <- metric_set(roc_auc, pr_auc, accuracy)
# 
# accuracy_log <- accuracy(log_preds, truth = target, estimate = .pred_class)|> 
#   select(.estimate) |> 
#   rename(Accuracy = .estimate) |> 
#   mutate(Model = "Logistic Regression")
# 
# accuracy <- bind_rows(
#      accuracy(log_preds, truth = target, estimate = .pred_class)|> 
#        select(.estimate) |> 
#        rename(Accuracy = .estimate) |> 
#        mutate(Model = "Logistic Regression"),
#    
#      accuracy(baseline_preds, truth = target, estimate = .pred_class)|> 
#        select(.estimate) |> 
#        rename(Accuracy = .estimate) |> 
#        mutate(Model = "Baseline Log")
#    )

# create tibble 
# write_csv(accuracy_log, here("figures/accuracy_log.csv"))
# write_csv(accuracy, here("figures/accuracy.csv"))
