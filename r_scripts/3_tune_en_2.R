# Define, fit, and tune elastic net model (glmnet)
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

# load resamples/folds & controls ----
load(here("data_splits/student_folds.rda"))

# load pre-processing/feature engineering/recipe ----
load(here("recipes/recipe_lm_2.rda"))

# model specifications ----
en_spec_2 <- multinom_reg(penalty = tune(), mixture = tune()) |> 
  set_engine("glmnet") |> 
  set_mode("classification")

# define workflows ----
en_wflow_2 <-
  workflow() |> 
  add_model(en_spec_2) |> 
  add_recipe(recipe_lm_2)

# hyperparameter tuning values ----
en_params <- extract_parameter_set_dials(en_spec_2)

en_grid <- grid_regular(en_params, levels = 5)

# fit workflow/model ----
# set seed
set.seed(2631)

tuned_en_2 <- tune_grid(en_wflow_2,
                       student_folds,
                       grid = en_grid,
                       control = control_grid(save_workflow = TRUE)
)

# write out results (fitted/trained workflows) ----
save(tuned_en_2, file = here("results/tuned_en_2.rda"))
