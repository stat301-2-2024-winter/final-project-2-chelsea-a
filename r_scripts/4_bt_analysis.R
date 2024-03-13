# Analysis of tuned boosted tree models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load trained models
load(here("results/tuned_bt.rda"))
load(here("results/tuned_bt_2.rda"))

# look at rf 1 metrics
tuned_bt |> 
  show_best("accuracy") |> 
  mutate(model = "bt 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    tuned_bt_2 |>
      show_best("accuracy") |>
      mutate(model = "bt 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
  ) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         `STD Error` = std_err) 

tuned_bt |> 
  show_best("roc_auc") |> 
  mutate(model = "bt 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    tuned_bt_2 |>
      show_best("roc_auc") |>
      mutate(model = "bt 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
  ) |> 
  select(`Model` = model,
         roc_auc,
         `STD Error` = std_err) 
