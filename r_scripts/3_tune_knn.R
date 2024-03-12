# Define, fit, and tune k-nearest neighbors model

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
load(here("recipes/recipe_tree.rda"))

# model specifications ----
knn_spec <- nearest_neighbor(mode = "classification",
                             neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_wflow <- workflow() |>
  add_model(knn_spec) |>
  add_recipe(recipe_tree)

# hyperparameter tuning values ----
knn_params <- extract_parameter_set_dials(knn_spec)

knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflow/model ----
# set seed
set.seed(1738)

tuned_knn <- tune_grid(knn_wflow,
                       student_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE)
                       )

# write out results (fitted/trained workflows) ----
save(tuned_knn, file = here("results/tuned_knn.rda"))
