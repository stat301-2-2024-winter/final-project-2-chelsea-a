# Analysis of tuned and trained models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load trained models
load(here("results/fit_null.rda"))
load(here("results/fit_multinom.rda"))
load(here("results/fit_multinom_2.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/fit_nbayes.rda"))
load(here("results/tuned_en.rda"))
load(here("results/tuned_en_2.rda"))
load(here("results/tuned_bt.rda"))
load(here("results/tuned_bt_2.rda"))
load(here("results/tuned_knn.rda"))

# look at multinomial models metrics
fit_multinom |> 
  collect_metrics() |> 
  mutate(model = "mn 1") |> 
  bind_rows(
    fit_multinom_2 |>
      collect_metrics() |> 
      mutate(model = "mn 2") 
    ) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         roc_auc,
         `STD Error` = std_err)


# look at elastic net models metrics
tuned_en |> 
  show_best("accuracy") |>
  slice_max(mean) |> 
  slice_head(n = 1) |>
  mutate(model = "en 1") |> 
  bind_rows(
    tuned_en_2 |>
      show_best("accuracy") |> 
      slice_max(mean) |> 
      slice_head(n = 1) |> 
      mutate(model = "en 2") 
  ) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         `STD Error` = std_err)

tuned_en |> 
  show_best("roc_auc") |>
  slice_max(mean) |> 
  slice_head(n = 1) |>
  mutate(model = "en 1") |> 
  bind_rows(
    tuned_en_2 |>
      show_best("roc_auc") |> 
      slice_max(mean) |> 
      slice_head(n = 1) |> 
      mutate(model = "en 2") 
  ) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         roc_auc,
         `STD Error` = std_err)

# look at boosted tree models metrics #.777
# 767 767
tuned_bt |> 
  show_best("accuracy") |>
  slice_max(mean) |> 
  mutate(model = "bt 1") |> 
  bind_rows(
    tuned_bt_2 |>
      show_best("accuracy") |> 
      slice_max(mean) |> 
      mutate(model = "bt 2") 
  ) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         `STD Error` = std_err)
#.881
# 863 864
tuned_bt |> 
  show_best("roc_auc") |>
  slice_max(mean) |> 
  mutate(model = "bt 1") |> 
  bind_rows(
    tuned_bt_2 |>
      show_best("roc_auc") |> 
      slice_max(mean) |> 
      mutate(model = "bt 2") 
  ) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |> 
  select(`Model` = model,
         roc_auc,
         `STD Error` = std_err)

# look at knn models metrics
tuned_knn |> 
  show_best("accuracy") |>
  slice_max(mean) |> 
  mutate(model = "knn")

tuned_knn |>
      show_best("roc_auc") |> 
      slice_max(mean) |> 
      mutate(model = "knn") 

# looking at accuracy of all models
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
        slice_max(mean) |> 
        select(mean, std_err, .metric) |> 
        mutate(model = "Random Forest")
      ) |>
  bind_rows(
    fit_multinom_2 |>
      collect_metrics() |> 
      mutate(model = "Multinomial") |> 
      select(-n, -.config, -.estimator)
    ) |> bind_rows(
      tuned_en_2 |> 
        show_best("accuracy") |> 
        slice_max(mean) |> 
        slice_head(n = 1) |> 
        select(mean, std_err, .metric) |> 
        mutate(model = "Elastic Net")
    ) |> 
  bind_rows(
    tuned_bt_2 |> 
      show_best("accuracy") |> 
      slice_max(mean) |> 
      select(mean, std_err, .metric) |> 
      mutate(model = "Boosted Tree")
  ) |>
  filter(.metric == "accuracy") |> 
  arrange(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean)   |> 
  select(`Model` = model,
         accuracy,
         `STD Error` = std_err)

# looking at roc_auc of all models
roc_auc_tbl <- tuned_rf |> 
  show_best("roc_auc") |> 
  slice_max(mean) |> 
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
    fit_multinom_2 |>
      collect_metrics() |> 
      mutate(model = "Multinomial") |> 
      select(-n, -.config, -.estimator)
    ) |>
  bind_rows(
      tuned_en_2 |> 
        show_best("roc_auc") |> 
        slice_max(mean) |> 
        slice_head(n = 1) |> 
        select(mean, std_err, .metric) |> 
        mutate(model = "Elastic Net")
    ) |>  
  bind_rows(
    tuned_bt_2 |> 
      show_best("roc_auc") |> 
      slice_max(mean) |> 
      select(mean, std_err, .metric) |> 
      mutate(model = "Boosted Tree")
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
