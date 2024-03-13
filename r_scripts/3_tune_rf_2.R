# Define and fit random forest 2
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
load(here("recipes/recipe_tree_2.rda"))

# model specifications ----
rf_spec_2 <- rand_forest(mtry = tune(),
                         #changing trees had no impact-- .727 and roc_auc is .854
                       trees = 200,
                       min_n = tune()) |>  
  set_mode("classification")|> 
  set_engine("ranger")

# define workflows ----
rf_wflow_2 <-
  workflow() |> 
  add_model(rf_spec_2) |> 
  add_recipe(recipe_tree_2)

keep_pred <- control_resamples(save_pred = TRUE)

# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_spec_2) |> 
  update(mtry = mtry(range = c(4, 14)))

rf_grid <- grid_regular(rf_params, levels = c(3, 8))

# fit workflows/models ----
# set seed
set.seed(9136)
tuned_rf_2 <- tune_grid(rf_wflow_2, 
                      student_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows) ----
save(tuned_rf_2, file = here("results/tuned_rf_2.rda"))
