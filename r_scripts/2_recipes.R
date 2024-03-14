# Setup pre-processing/recipes/feature engineering

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data ----
load(here("data_splits/student_train.rda"))

# build starter lm recipe  ----
recipe_lm_base <- recipe(target ~ ., data = student_train) |> 
  step_dummy(all_nominal_predictors()) 

recipe_lm_base |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# build lm recipe ----
# recipe 

recipe_lm <- recipe(target ~ ., data = student_train) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_interact(terms = ~ mothers_occupation:fathers_occupation) |>
  step_interact(terms = ~ ends_with("1st_sem_credited"):ends_with("2nd_sem_credited")) |>
  step_interact(terms = ~ ends_with("1st_sem_enrolled"):ends_with("2nd_sem_enrolled")) |>
  step_interact(terms = ~ ends_with("1st_sem_evaluations"):ends_with("2nd_sem_evaluations")) |>
  step_interact(terms = ~ ends_with("1st_sem_approved"):ends_with("2nd_sem_approved")) |>
  step_interact(terms = ~ ends_with("1st_sem_grade"):ends_with("2nd_sem_grade")) 

recipe_lm |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# build lm recipe 2 ----
# differences: two step interacts: parents' qualification and units without evaluations


recipe_lm_2 |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# build tree recipe ----
# recipe 1
recipe_tree <- recipe(target ~ ., data = student_train) |>
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

recipe_tree |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# recipe 2
recipe_tree_2 <- recipe(target ~ ., data = student_train) |>
  step_rm(gdp, inflation_rate, unemployment_rate, fathers_qualification, mothers_qualification,
          fathers_occupation, mothers_occupation) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_nzv(all_predictors()) |>
  step_normalize(all_numeric_predictors())

recipe_tree_2 |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# build nbayes recipe ----
recipe_naive_bayes <- recipe(target ~ ., data = student_train) |> 
  step_dummy(all_nominal_predictors(), one_hot = TRUE) |> 
  step_nzv(all_predictors()) 

recipe_naive_bayes |> 
  prep() |> 
  bake(new_data = NULL) |> 
  glimpse()

# write out recipe(s) ----
save(recipe_lm_base, file = here("recipes/recipe_lm_base.rda"))
save(recipe_lm, file = here("recipes/recipe_lm.rda"))
save(recipe_lm_2, file = here("recipes/recipe_lm_2.rda"))
save(recipe_tree, file = here("recipes/recipe_tree.rda"))
save(recipe_tree_2, file = here("recipes/recipe_tree_2.rda"))
save(recipe_naive_bayes, file = here("recipes/recipe_naive_bayes.rda"))
