# Assess final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load testing data
load(here("data_splits/student_test.rda"))

# load fitted model
load(here("results/final_fit_bt.rda"))

# extract predictions 
pred_data <- predict(final_fit_bt, student_test)

# match predictions to outcome values 
student_preds <- bind_cols(pred_data, student_test) |> 
  select(.pred_class, target)

# collect performance metrics
student_metrics <- 
  student_test |>
  select(target) |>
  bind_cols(predict(final_fit_bt, student_test)) |>
  accuracy(target, .pred_class) |> 
  select(-.estimator)

write_csv(student_metrics, here("figures/student_metrics.csv"))

# confusion matrix
conf_mat <- conf_mat(student_preds, truth = target, estimate = .pred_class)
saveRDS(conf_mat, here("figures/conf_mat.rds"))

