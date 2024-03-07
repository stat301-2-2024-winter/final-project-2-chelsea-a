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
load(here("exercise_2/data_splits/titanic_folds.rda"))

# load pre-processing/feature engineering/recipe ----
load(here("recipes/recipe_tree.rda"))

# model specifications ----


# define workflows ----


# hyperparameter tuning values ----


# fit workflow/model ----
# set seed
set.seed(3789)


# write out results (fitted/trained workflows) ----