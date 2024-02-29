# Initial data visualization and plotting 

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)

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
                                             labels = c("No", "Yes")),
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
         target = factor(target)
  )

# initial skim
student_data |> skimr::skim_without_charts()
student_data |> names() 

# plots 
ggplot(student_data, aes(target)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal() +
  labs(x = "Target Variable", y = "Count", title = "Distribution of Target Variable")

# gender and semester grade
ggplot(student_data, aes(gender, curricular_units_1st_sem_grade)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal() 

ggplot(student_data, aes(gender, curricular_units_2nd_sem_grade)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal() 

# there is a relationship between grade and gender 

# gender and units enrolled
ggplot(student_data, aes(gender, curricular_units_2nd_sem_enrolled)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal()

ggplot(student_data, aes(gender, curricular_units_1st_sem_enrolled)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal() 
# small interaction between enrolled and gender

# age and gender 
ggplot(student_data, aes(gender, age_at_enrollment,)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  geom_smooth() +
  theme_minimal() 
# interaction between gender and age of enrollement 

# marital status and units enrolled / admission grade 
plot1 <- ggplot(student_data, aes(marital_status, admission_grade)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal() 

plot2 <- 
  ggplot(student_data, aes(marital_status, curricular_units_1st_sem_grade)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal() 

plot1/plot2

ggplot(student_data, aes(marital_status, curricular_units_2nd_sem_grade)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal() 
# interaction between grade and marriage status

ggplot(student_data, aes(x = course, y = curricular_units_st_sem_credited, fill = course)) +
  geom_boxplot() +
  labs(x = "Category", y = "Numeric Variable", title = "Box Plot")

student_data |> names()

student_data |> 
  count(target) |> 
  knitr::kable()