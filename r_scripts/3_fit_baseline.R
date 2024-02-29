# Define and fit ordinary linear regression
# Random process in script, seed set right before it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load resamples/folds ----
load(here("data_splits/student_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/recipe_baseline.rda"))

# Null Model ----
# set seed
set.seed(847)
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("classification")

null_wflow <- workflow() |> 
  add_model(null_spec) |> 
  add_recipe(recipe_baseline)

null_fit <- null_wflow |> 
  fit_resamples(resample = student_folds, 
                control = control_resamples(save_workflow = TRUE))

save(null_fit, file = here("results/fit_null.rda"))

# Basic baseline ----
# set seed
set.seed(394)

baseline_spec <- logistic_reg() |>
  set_engine("glm") |> 
  set_mode("classification")

baseline_wflow <- workflow() |>
  add_model(baseline_spec) |>
  add_recipe(recipe_baseline)

baseline_fit <- baseline_wflow |>
  fit_resamples(resamples = student_folds,
                control = control_resamples(save_workflow = TRUE))

fit_baseline <- fit(baseline_wflow, data = student_train)

save(baseline_fit, file = here("results/fit_baseline.rda"))
