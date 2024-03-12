# Define, fit, and tune boosted tree model (xgboost)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(xgboost)

# handle common conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load resamples/folds & controls ----
load(here("data_splits/student_folds.rda"))

# load pre-processing/feature engineering/recipe ----
load(here("recipes/recipe_tree.rda"))

# model specifications ----
bt_spec <-
  boost_tree(trees = tune(), learn_rate = tune(), mtry = tune(), min_n = tune()) |> 
  set_engine("xgboost") |> 
  set_mode("classification")

# define workflows ----
bt_wflow <- 
  workflow() |> 
  add_model(bt_spec) |> 
  add_recipe(recipe_tree)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_spec) |> 
  update(mtry = mtry(range = c(1, 14)),
         min_n = min_n(range = c(1, 1)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflow/model ----
# set seed
set.seed(7342)

tuned_bt <- tune_grid(bt_wflow, 
                      student_folds,
                      grid = bt_grid,
                      control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows) ----
save(tuned_bt, file = here("results/tuned_bt.rda"))