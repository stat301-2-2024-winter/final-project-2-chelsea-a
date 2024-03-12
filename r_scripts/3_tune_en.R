# Define, fit, and tune elastic net model (glmnet)

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

# load resamples/folds & controls ----
load(here("data_splits/student_folds.rda"))

# load pre-processing/feature engineering/recipe ----
load(here("recipes/recipe_lm.rda"))

# model specifications ----
en_spec <- multinom_reg(penalty = tune(), mixture = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("classification")

# define workflows ----
en_wflow <-
  workflow() |> 
  add_model(en_spec) |> 
  add_recipe(recipe_lm)

# hyperparameter tuning values ----
en_params <- extract_parameter_set_dials(en_spec)

en_grid <- grid_regular(en_params, levels = 5)

# fit workflow/model ----
# set seed
set.seed(678)

tuned_en <- tune_grid(en_wflow,
                       student_folds,
                       grid = en_grid,
                       control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows) ----
save(tuned_en, file = here("results/tuned_en.rda"))
