# Train final model
# Random process in script, seed set right before it

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

# load training and testing data
load(here("data_splits/student_train.rda"))

# load trained models
load(here("results/tuned_bt.rda"))

# finalize workflow
final_wflow_bt <- tuned_bt |> 
  extract_workflow(tuned_bt) |>  
  finalize_workflow(select_best(tuned_bt, metric = "accuracy"))

# train final model
# set seed
set.seed(28625)
final_fit_bt <- fit(final_wflow_bt, student_train)

# write out results (fitted/trained workflows) ----
save(final_fit_bt, file = here("results/final_fit_bt.rda"))





