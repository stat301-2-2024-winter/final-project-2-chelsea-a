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
  step_normalize(all_numeric_predictors()) |> 
  step_interact(terms = ~ starts_with("gender_"):ends_with("_sem_grade")) |> 
  step_interact(terms = ~ starts_with("marital_status_"):ends_with("_sem_grade"))

# build tree recipe ----
recipe_tree <- recipe(target ~ ., data = student_train) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_center(all_predictors()) |> 
  step_scale(all_predictors()) 

recipe_tree |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

recipe_tree |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

save(recipe_lm, file = here("recipes/recipe_lm.rda"))
save(recipe_tree, file = here("recipes/recipe_tree.rda"))
