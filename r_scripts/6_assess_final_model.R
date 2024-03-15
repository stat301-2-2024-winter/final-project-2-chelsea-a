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
pred_results <- predict(final_fit_bt, student_test)

# match predictions to outcome values -- this is putting predictions next to observed outcomes in test data
student_results <- bind_cols(pred_results, student_test) |> 
  select(.pred_class, target)

# store predictions 
saveRDS(student_results, here("results/student_results.rds"))

# collect performance metrics

model_accuracy <- 
  accuracy(student_results, truth = target, estimate = .pred_class) |> 
  select(.estimate) |> 
  rename(Accuracy = .estimate) |> 
  mutate(Model = "Final Boosted Tree") |> 
  select(Model, Accuracy)

write_csv(model_accuracy, here("figures/final_model_accuracy.csv"))

# find the area under the curve
pred_prob <- predict(final_fit_bt, student_test, type = "prob")

student_results <- student_results |> 
  select(target, .pred_class) |> 
  bind_cols(pred_prob)

# roc auc
model_rocauc <- 
  roc_auc(student_results, target, c(.pred_Dropout, .pred_Enrolled, .pred_Graduate)) |> 
  select(.estimate) |> 
  rename("ROC AUC" = .estimate) |> 
  mutate(Model = "Final Boosted Tree") |> 
  select(Model, "ROC AUC")

write_csv(model_rocauc, here("figures/final_model_rocauc.csv"))

# Visualize results 
student_curve <- roc_curve(student_results, target, c(.pred_Dropout, .pred_Enrolled, .pred_Graduate))

student_curve <- autoplot(student_curve)
ggsave(here("figures/student_curve.png"), student_curve, width = 8,
       height = 3.25, units = "in", dpi = 300)

# confusion matrix
conf_mat <- conf_mat(student_results, truth = target, estimate = .pred_class)

conf_mat <- as.data.frame.matrix(conf_mat$table) 

saveRDS(conf_mat, here("figures/conf_mat.rds"))


           