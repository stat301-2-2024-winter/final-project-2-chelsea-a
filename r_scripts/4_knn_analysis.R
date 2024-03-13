# Analysis of tuned k nearest neighbors models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load trained models
load(here("results/tuned_knn.rda"))
load(here("results/tuned_knn_2.rda"))

# look at rf 1 metrics
tuned_knn|> 
  show_best("accuracy") |> 
  mutate(model = "knn 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    tuned_knn_2 |>
      show_best("accuracy") |>
      mutate(model = "knn 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
  ) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         `STD Error` = std_err) 

tuned_knn|> 
  show_best("roc_auc") |> 
  mutate(model = "knn 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    tuned_knn_2 |>
      show_best("roc_auc") |>
      mutate(model = "knn 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
  ) |> 
  select(`Model` = model,
         roc_auc,
         `STD Error` = std_err) 

# knn 2 performed better in accuracy and roc_auc