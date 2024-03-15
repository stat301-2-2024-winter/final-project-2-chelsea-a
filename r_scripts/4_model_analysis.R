# Analysis of tuned and trained models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load trained models
load(here("results/fit_null.rda"))
load(here("results/fit_multinom_2.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/fit_nbayes.rda"))
load(here("results/tuned_en_2.rda"))
load(here("results/tuned_bt.rda"))
load(here("results/tuned_knn_2.rda"))

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
    tuned_bt |> 
      show_best("accuracy") |> 
      slice_max(mean) |> 
      select(mean, std_err, .metric) |> 
      mutate(model = "Boosted Tree")
  ) |>
  bind_rows(
    tuned_knn_2 |> 
      show_best("accuracy") |> 
      slice_max(mean) |> 
      select(mean, std_err, .metric) |> 
      mutate(model = "K nearest neighbor")
  ) |>
  filter(.metric == "accuracy") |> 
  arrange(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean)   |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
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
    tuned_bt |> 
      show_best("roc_auc") |> 
      slice_max(mean) |> 
      select(mean, std_err, .metric) |> 
      mutate(model = "Boosted Tree")
  ) |> 
  bind_rows(
    tuned_knn_2 |> 
      show_best("roc_auc") |> 
      slice_max(mean) |> 
      select(mean, std_err, .metric) |> 
      mutate(model = "K nearest neighbor")
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

write_csv(acc_table, here("figures/acc_table.csv"))
write_csv(roc_auc_tbl, here("figures/roc_auc_tbl.csv"))

read_csv(here("figures/model_rocauc.csv"))
