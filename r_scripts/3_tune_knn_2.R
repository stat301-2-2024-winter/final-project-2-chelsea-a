# Define, fit, and tune k-nearest neighbors model
# Random process in script, seed set right before it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(kknn)

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
knn_spec_2 <-
  nearest_neighbor(neighbors = tune(), weight_func = tune(), dist_power = tune()) |> 
  set_engine('kknn') |> 
  set_mode('classification')

# define workflows ----
knn_wflow_2 <- workflow() |>
  add_model(knn_spec_2) |>
  add_recipe(recipe_tree_2)

# hyperparameter tuning values ----
knn_params <- extract_parameter_set_dials(knn_spec_2)

knn_grid <- grid_regular(knn_params, levels = 3)

# fit workflow/model ----
# set seed
set.seed(1423)

tuned_knn_2 <- tune_grid(knn_wflow_2,
                       student_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE)
                       )

# write out results (fitted/trained workflows) ----
save(tuned_knn_2, file = here("results/tuned_knn_2.rda"))
