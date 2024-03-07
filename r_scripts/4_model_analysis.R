# Analysis of tuned and trained models (comparisons)

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/student_train.rda"))

# load trained models
load(here("results/fit_null.rda"))
load(here("results/fit_baseline.rda"))
load(here("results/fit_log.rda"))
load(here("results/tuned_rf.rda"))
load(here("results/fit_nbayes.rda"))

# inspecting model fit 
fit_log |> 
  tidy()

null_fit |> collect_metrics()

tuned_rf |> collect_metrics()

# failed bc i used logistic regression which models binary outcomes
fit_baseline |>  collect_metrics()
fit_log |> collect_metrics()

fit_nbayes |>  collect_metrics()

# extract predictions 
pred_data_log <- predict(fit_log, student_train) 

pred_baseline <- predict(fit_baseline, student_train) 

best_rf_model <- select_best(tuned_rf, "roc_auc")

# match predictions to outcome values 
log_preds <- bind_cols(pred_data_log, student_train) |> 
  select(.pred_class, target)

baseline_preds <- bind_cols(pred_baseline, student_train) |>
  select(.pred_class, target)

# create a metric set 
student_metrics <- metric_set(roc_auc, pr_auc, accuracy)

accuracy_log <- accuracy(log_preds, truth = target, estimate = .pred_class)|> 
  select(.estimate) |> 
  rename(Accuracy = .estimate) |> 
  mutate(Model = "Logistic Regression")

accuracy <- bind_rows(
     accuracy(log_preds, truth = target, estimate = .pred_class)|> 
       select(.estimate) |> 
       rename(Accuracy = .estimate) |> 
       mutate(Model = "Logistic Regression"),
   
     accuracy(baseline_preds, truth = target, estimate = .pred_class)|> 
       select(.estimate) |> 
       rename(Accuracy = .estimate) |> 
       mutate(Model = "Baseline Log")
   )

# create tibble 
write_csv(accuracy_log, here("figures/accuracy_log.csv"))
write_csv(accuracy, here("figures/accuracy.csv"))
