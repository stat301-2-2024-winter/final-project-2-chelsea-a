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
load(here("recipes/recipe_lm.rda"))

# model specifications ----
lm_spec <-
  linear_reg() |> 
  set_engine("lm") 

# define workflows ----
lm_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(recipe_lm)

keep_pred <- control_resamples(save_pred = TRUE)

# fit workflows/models ----
# set seed
set.seed(4062)
fit_lm <- lm_wflow |> 
  fit_resamples(
    resamples = student_folds,
    control = keep_pred
  )

# write out results (fitted/trained workflows) ----
save(fit_lm, file = here("results/fit_lm.rda"))
