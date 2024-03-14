# Analysis of tuned random forest models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load trained models
load(here("results/tuned_rf.rda"))
load(here("results/tuned_rf_2.rda"))

# look at rf accuracy
tuned_rf |> 
  show_best("accuracy") |> 
  mutate(model = "rf 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    tuned_rf_2 |>
      show_best("accuracy") |>
      mutate(model = "rf 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
    ) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         `STD Error` = std_err) 

# look at rf roc_auc
tuned_rf |> 
  show_best("roc_auc") |> 
  mutate(model = "rf 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    tuned_rf_2 |>
      show_best("roc_auc") |>
      mutate(model = "rf 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
  ) |> 
  select(`Model` = model,
         roc_auc,
         `STD Error` = std_err) 

# rf 1 is better in accuracy and roc_auc
