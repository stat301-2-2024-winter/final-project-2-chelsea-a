# Define and fit second multinomial regression
# Random process in script, seed set right before it
# multinomial regression multinom_reg (engine = neural network)

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
load(here("recipes/recipe_lm_2.rda"))

# fit second multinomial model
# model specifications ----
multinom_reg_nnet_spec_2 <-
  multinom_reg(penalty = 0) |> 
  set_engine('nnet') |> 
  set_mode("classification")

# define workflows ----
mn_wflow_2 <-
  workflow() |> 
  add_model(multinom_reg_nnet_spec_2) |> 
  add_recipe(recipe_lm_2)

keep_pred_2 <- control_resamples(save_pred = TRUE)

# fit workflows/models ----
# set seed
set.seed(456)
fit_multinom_2 <- mn_wflow_2 |> 
  fit_resamples(
    resamples = student_folds
  )

# write out results (fitted/trained workflows) ----
save(fit_multinom_2, file = here("results/fit_multinom_2.rda"))
