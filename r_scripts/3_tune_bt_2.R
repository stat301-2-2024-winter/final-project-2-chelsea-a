# Define, fit, and tune boosted tree model 2 (xgboost)
# Random process in script, seed set right before it

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
load(here("recipes/recipe_tree_2.rda"))

# model specifications ----
bt_spec_2 <-
  boost_tree(trees = tune(),
             learn_rate = tune(),
             mtry = tune(),
             min_n = tune()
             ) |> 
  set_engine("xgboost") |> 
  set_mode("classification")

# define workflows ----
bt_wflow_2 <- 
  workflow() |> 
  add_model(bt_spec_2) |> 
  add_recipe(recipe_tree_2)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_spec_2) |> 
  update(trees = trees(range = c(100, 750)),
         learn_rate = learn_rate(range = c(0.01, 0.3), trans = scales::identity_trans()),
         mtry = mtry(range = c(3, 18))
         )

# build tuning grid
bt_grid <- grid_regular(bt_params, levels =  3)

# fit workflow/model ----
# set seed
set.seed(6573)

tuned_bt_2 <- tune_grid(bt_wflow_2, 
                      student_folds,
                      grid = bt_grid,
                      control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows) ----
save(tuned_bt_2, file = here("results/tuned_bt_2.rda"))