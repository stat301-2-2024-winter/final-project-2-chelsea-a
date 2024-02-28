# Setup pre-processing/recipes/feature engineering

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data ----
load(here("data_splits/student_train.rda"))

# build lm recipe ----
recipe(target ~ ., data = student_train) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_normalize(all_numeric_predictors())

# build rf recipe ----
recipe(target ~ ., data = student_train) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors())


