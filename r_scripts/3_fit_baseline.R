# Define and fit ordinary linear regression
# Random process in script, seed set right before it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)
library(discrim)
library(klaR)

# handle common conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# load resamples/folds ----
load(here("data_splits/student_folds.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/recipe_naive_bayes.rda"))

# Null Model ----
# set seed
set.seed(847)
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("classification")

null_wflow <- workflow() |> 
  add_model(null_spec) |> 
  add_recipe(recipe_baseline)

null_fit <- null_wflow |> 
  fit_resamples(resample = student_folds, 
                control = control_resamples(save_workflow = TRUE))

save(null_fit, file = here("results/fit_null.rda"))

# Basic baseline ----
# set seed
set.seed(394)

nbayes_spec <- naive_Bayes() |>
  set_engine("klaR") |> 
  set_mode("classification")

nbayes_wflow <- workflow() |>
  add_model(nbayes_spec) |>
  add_recipe(recipe_naive_bayes)

fit_nbayes <- nbayes_wflow |>
  fit_resamples(resamples = student_folds,
                control = control_resamples(save_workflow = TRUE))

save(fit_nbayes, file = here("results/fit_nbayes.rda"))

# failed baseline 
# Basic baseline ----
# set seed
#  set.seed(394)
# 
#  baseline_spec <- logistic_reg() |>
#      set_engine("glm") |> 
#      set_mode("classification")
# 
# > baseline_wflow <- workflow() |>
#   +   add_model(baseline_spec) |>
#   +   add_recipe(recipe_baseline)
# 
# > baseline_fit <- baseline_wflow |>
#   +   fit_resamples(resamples = student_folds,
#                     +                 control = control_resamples(save_workflow = TRUE))
# 
# > fit_baseline <- fit(baseline_wflow, data = student_train)
# 
# > save(fit_baseline, file = here("results/fit_baseline.rda"))
# Warning messages:
#   1: All models failed. Run `show_notes(.Last.tune.result)` for more information. 
# 2: ! Logistic regression is intended for modeling binary outcomes, but
# there are 3 levels in the outcome.
# ℹ If this is unintended, adjust outcome levels accordingly or see the
# `multinom_reg()` function. 
# 3: ! Logistic regression is intended for modeling binary outcomes, but
# there are 3 levels in the outcome.
# ℹ If this is unintended, adjust outcome levels accordingly or see the
# `multinom_reg()` function. 
