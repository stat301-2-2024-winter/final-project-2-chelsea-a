# Initial data checks & data splitting

# Random process in script, seed set right before it

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data
student_data <- read_delim(here("data/data.csv"), delim=";") |> 
  janitor::clean_names() |> 
  rename(nationality = nacionality) |> 
  mutate(marital_status = factor(marital_status,
                                 levels = c(1, 2, 3, 4, 5, 6),
                                 labels = c("Single", "Married", "Widower",
                                            "Divorced", "Facto union", "Legally separated")),
         daytime_evening_attendance = factor(daytime_evening_attendance,
                                             levels = c(0, 1),
                                             labels = c("Evening", "Daytime")),
         displaced = factor(displaced,
                            levels = c(0, 1),
                            labels = c("No", "Yes")),
         educational_special_needs = factor(educational_special_needs,
                                            levels = c(0, 1),
                                            labels = c("No", "Yes")),
         debtor = factor(debtor,
                         levels = c(0, 1),
                         labels = c("No", "Yes")),
         tuition_fees_up_to_date = factor(tuition_fees_up_to_date,
                                          levels = c(0, 1),
                                          labels = c("No", "Yes")),
         gender = factor(gender, 
                         levels = c(0, 1),
                         labels = c("Female", "Male")),
         scholarship_holder = factor(scholarship_holder,
                                     levels = c(0, 1),
                                     labels = c("No", "Yes")),
         international = factor(international,
                                levels = c(0, 1),
                                labels = c("No", "Yes")),
         target = factor(target, levels = c("Dropout", "Enrolled", "Graduate"))
  )

# initial skim
ggplot(student_data, aes(target)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(x = "Target Variable", y = "Count", title = "Distribution of Target Variable")

student_data |> 
  count(target) |> 
  knitr::kable()

# initial split ----
# set seed
set.seed(1234)
student_split <- student_data |>  
  initial_split(prop = 0.8, strata = target) 

student_train <- student_split |> training()
student_test <- student_split |> testing()

# folding data (resamples) ----
# set seed 
set.seed(5678)
student_folds <-
  vfold_cv(student_train,
           v = 10, repeats = 5, strata = target)

# set up controls for fitting resamples ----
keep_wflow <- control_resamples(save_pred = TRUE, save_workflow = TRUE)

# write out split, train, test and folds ----
save(student_split, file = here("data_splits/student_split.rda"))
save(student_train, file = here("data_splits/student_train.rda"))
save(student_test, file = here("data_splits/student_test.rda"))
save(student_folds, file = here("data_splits/student_folds.rda"))
save(keep_wflow, file = here("data_splits/keep_wflow.rda"))