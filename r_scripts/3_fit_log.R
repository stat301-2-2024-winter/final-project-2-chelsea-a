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
load(here("recipes/recipe_log.rda"))

# model specifications ----
log_spec <- 
  logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification")

# define workflows ----
log_wflow <-
  workflow() |> 
  add_model(log_spec) |> 
  add_recipe(recipe_log)

keep_pred <- control_resamples(save_pred = TRUE)

# fit workflows/models ----
# set seed
set.seed(4062)
fit_log <- log_wflow |> 
  fit_resamples(
    resamples = student_folds
  )

# write out results (fitted/trained workflows) ----
save(fit_log, file = here("results/fit_log.rda"))
