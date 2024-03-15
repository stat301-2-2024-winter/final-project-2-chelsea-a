# Assess final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load predictions
readRDS(here("results/student_results.rds"))

student_accuracy <- student_results |> 
  group_by(target) |> 
  summarise(accuracy = sum(.pred_class == target) / n())

# Visualize class-wise accuracy
accuracy_plot <- ggplot(student_accuracy, aes(x = reorder((target), -accuracy), y = accuracy, fill = target)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = scales::percent(accuracy)),
            position = position_stack(vjust = 0.5), color = "white") +
  scale_fill_brewer(palette = "Set2") +
  labs(title = NULL, x = NULL, y = "Accuracy", fill = NULL) +
  theme_minimal()

ggsave("figures/accuracy_plot.png", accuracy_plot, width = 8, height = 6)

# which predictors were most important
importance <- final_fit_bt |> 
  vip::vip(num_features = 15)

important_plot <- importance + 
  geom_bar(stat = "identity", fill = "deepskyblue3") +
  theme_minimal() 

ggsave("figures/important.png", important_plot, width = 8, height = 6)