## Overview

Directory contains initial setup objects for the project created in [r_scripts/1_initial_setup.R](https://github.com/stat301-2-2024-winter/final-project-2-chelsea-a/blob/main/r_scripts/1_initial_setup.R)

- `student_split.rda`: Split object; result of performing an initial split; can derive the testing and training dataset from this object
- `student_train.rda`: student training dataset; derived from `student_split`
- `student_test.rda`: student testing dataset; derived from `student_split`
- `student_folds.rda`: Object identifying how the training set should be folded (resampling technique used for tuning and out of sample model performance estimation)
- `keep_wflow.rda`: Extra controls indicated what to save when tuning/training on a regular grid