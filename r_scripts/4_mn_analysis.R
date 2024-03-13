# Analysis of multinomial models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load trained models
load(here("results/fit_multinom.rda"))
load(here("results/fit_multinom_2.rda"))

# look at mn accuracy
fit_multinom |> 
  show_best("accuracy") |> 
  mutate(model = "mn 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    fit_multinom_2 |>
      show_best("accuracy") |>
      mutate(model = "mn 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
  ) |> 
  select(`Model` = model,
         `Accuracy` = accuracy,
         `STD Error` = std_err) 

# look at mn roc_auc
fit_multinom |> 
  show_best("roc_auc") |> 
  mutate(model = "mn 1") |>
  slice_max(mean) |> 
  pivot_wider(names_from = .metric,
              values_from = mean) |>
  bind_rows(
    fit_multinom_2 |>
      show_best("roc_auc") |>
      mutate(model = "mn 2") |>
      slice_max(mean) |> 
      pivot_wider(names_from = .metric,
                  values_from = mean)
  ) |> 
  select(`Model` = model,
         roc_auc,
         `STD Error` = std_err) 

# mn 2 performs better in accuracy