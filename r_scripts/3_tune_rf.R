# Define and fit random forest 
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
load(here("recipes/recipe_tree.rda"))

# model specifications ----
rf_spec <- rand_forest(mtry = tune(),
                       trees = 1000,
                       min_n = tune()) |>  
  set_mode("classification")|> 
  set_engine("ranger")

# define workflows ----
rf_wflow <-
  workflow() |> 
  add_model(rf_spec) |> 
  add_recipe(recipe_tree)

keep_pred <- control_resamples(save_pred = TRUE)

# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_spec) |> 
  update(mtry = mtry(range = c(6, 18)))

rf_grid <- grid_regular(rf_params, levels = c(3, 6))

# fit workflows/models ----
# set seed
set.seed(2571)
tuned_rf <- tune_grid(rf_wflow, 
                      student_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows) ----
save(tuned_rf, file = here("results/tuned_rf.rda"))
