# Initial data visualization and plotting 

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(patchwork)
library(GGally)


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
         target = factor(target)) 
  # rename(mqual = mothers_qualification,
  #        dqual = fathers_qualification,
  #        mjob = mothers_occupation,
  #        djob = fathers_occupation,
  #        admit_gr = admission_grade,
  #        pr_qual = previous_qualification,
  #        pr_qual_grade = previous_qualification_grade,
  #        age = age_at_enrollment,
  #        unemp = unemployment_rate,
  #        int = international,
  #      cred_1st = curricular_units_1st_sem_credited,
  #      enr_1st = curricular_units_1st_sem_enrolled,
  #      eval_1st = curricular_units_1st_sem_evaluations,
  #      appr_1st = curricular_units_1st_sem_approved,
  #      grade_1st = curricular_units_1st_sem_grade,
  #      noeval_1st = curricular_units_1st_sem_without_evaluations,
  #      cred_2nd = curricular_units_2nd_sem_credited,
  #      enr_2nd = curricular_units_2nd_sem_enrolled,
  #      eval_2nd = curricular_units_2nd_sem_evaluations,
  #      appr_2nd = curricular_units_2nd_sem_approved,
  #      grade_2nd = curricular_units_2nd_sem_grade,
  #      noeval_2nd = curricular_units_2nd_sem_without_evaluations,
  #        infl_rate = inflation_rate,
  #      app_mode = application_mode,
  #      app_order = application_order    
  # )

# initial skim
student_data |> skimr::skim_without_charts()
student_data |> names() 

# target variable and predictors 

numeric_variables <- sapply(student_data, is.numeric)
correlation_matrix <- cor(student_data[, numeric_variables])
ggcorr_plot <- ggcorr(correlation_matrix, label = TRUE)
ggsave("figures/correlation_plot2.png", ggcorr_plot,  width = 8, height = 6)
# what has high correlation 
# mom and dad job
# mom and dad qual
# age and app mode 
# prev qual grade and admit grade 

# cred 1st and enrolled 1st
# cred 1st and eval 1st
# cred 1st and appr 1st

# enr 1st and eval 1st
# enr 1st and appr 1st

# eval 1st and appr 1st

# appr 1st and grade 1st

# cred 2nd and appr 1st
# cred 2nd and eval 1st
# cred 2nd and enrolled 1st
# cred 2nd and cred 1st

# enr 2nd and appr 1st
# enr 2nd and eval 1st
# enr 2nd and enrolled 1st
# enr 2nd and cred 1st
# enr 2nd and cred 2nd

# eval 2nd and appr 1st
# eval 2nd and eval 1st
# eval 2nd and enrolled 1st
# eval 2nd and enr 2nd

# appr 2nd and appr 1st
# appr 2nd and eval 2nd
# appr 2nd and enrolled 2nd
# appr 2nd and grade 1st
# appr 2nd and enr 1st

# grade 2nd and appr 2nd
# grade 2nd and grade 1st
# grade 2nd and appr 1st

# no eval 2nd and no eval 1st

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
# very small interaction between enrolled and gender

# age and gender 
ggplot(student_data, aes(gender, age_at_enrollment)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  geom_smooth() +
  theme_minimal() 
# interaction between gender and age of enrollment 

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

ggplot(student_data, aes(x = marital_status, fill = daytime_evening_attendance)) +
  geom_bar(position = "stack", width = 0.7) +
  theme_minimal() 

ggplot(student_data, aes(x = gender, fill = daytime_evening_attendance)) +
  geom_bar(position = "stack", width = 0.7) +
  theme_minimal() 
# interaction between daytime_evening attendance and marital status 

ggplot(student_data, aes(international, admission_grade)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  theme_minimal() 

ft <- student_data |> filter(international == "Yes")

median(ft$admission_grade)

ft2 <- student_data |> filter(international == "No")
median(ft2$admission_grade)
# interaction between admission grade and international 

student_data |> 
  filter(international == "Yes") |> 
  ggplot(aes(x = gender)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal()
# interaction between international and gender

student_data |> 
  filter(international == "Yes") |> 
  ggplot(aes(x = gender)) +
  geom_bar(fill = "skyblue", color = "black") +
  theme_minimal()

ggplot(student_data, aes(x = debtor, fill = scholarship_holder)) +
  geom_bar(position = "stack", width = 0.7) +
  theme_minimal() 

student_data |> 
  count(target) |> 
  knitr::kable()