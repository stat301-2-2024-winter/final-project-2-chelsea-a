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
recipe_lm <- recipe(target ~ ., data = student_train) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_interact(terms = ~ starts_with("gender_"):ends_with("_sem_grade")) |> 
  step_interact(terms = ~ starts_with("marital_status_"):ends_with("_sem_grade"))

recipe_lm |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# build tree recipe ----
# recipe 1
recipe_tree <- recipe(target ~ ., data = student_train) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors()) 

recipe_tree |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# recipe 2
recipe_tree_2 <- recipe(target ~ ., data = student_train) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors()) 

# build baseline recipe ----
recipe_naive_bayes <- recipe(target ~ ., data = student_train) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_numeric_predictors())

recipe_baseline |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# write out recipe(s) ----
save(recipe_lm, file = here("recipes/recipe_lm.rda"))
save(recipe_tree, file = here("recipes/recipe_tree.rda"))
save(recipe_naive_bayes, file = here("recipes/recipe_naive_bayes.rda"))

