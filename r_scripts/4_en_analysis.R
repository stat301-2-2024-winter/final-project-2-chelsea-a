# Analysis of elastic net models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load trained models
load(here("results/tuned_en.rda"))
load(here("results/tuned_en_2.rda"))

# look at elastic net accuracy
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

# look at elastic net roc_auc
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

# en 2 performs better in accuracy