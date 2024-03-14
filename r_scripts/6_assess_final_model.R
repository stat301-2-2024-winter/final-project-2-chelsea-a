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

# match predictions to outcome values -- this is putting predictions next to observed outcomes in test data
student_preds <- bind_cols(pred_data, student_test) |> 
  select(.pred_class, target)

# collect performance metrics

  student_test |>
  select(target) |>
  bind_cols(predict(final_fit_bt, student_test)) |>
  accuracy(target, .pred_class) |> 
  select(-.estimator)

model_accuracy <- 
accuracy(student_preds, truth = target, estimate = .pred_class) |> 
  select(.estimate) |> 
  rename(Accuracy = .estimate) |> 
  mutate(Model = "Final Boosted Tree") |> 
  select(Model, Accuracy)

write_csv(student_metrics, here("figures/model_accuracy.csv"))

# calculate the area under the ROC curve
roc <- student_preds |> 
  mutate(pred_probs = as.numeric(.pred_class == "Dropout")) |>
  select(-.pred_class)

roc_auc(roc, truth = target, 3)


# Create the ROC curve using predicted probabilities
titanic_roc_curve <- student_preds |> 
  mutate(pred_probs = as.numeric(.pred_class == "Yes")) |>
  select(-.pred_class)

roc_data <- roc_curve(titanic_roc_curve, truth = survived, pred_probs)

roc_curve <- autoplot(roc_data)

ggsave(here("exercise_2/results/roc_curve.png"), autoplot, width = 8,
       height = 6, units = "in", dpi = 300)


# 
# confusion matrix
conf_mat <- conf_mat(student_preds, truth = target, estimate = .pred_class)
saveRDS(conf_mat, here("figures/conf_mat.rds"))

