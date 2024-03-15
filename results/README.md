## Overview

Directory contains results from all scripts used for fitting/training and/or tuning models. 

- `fit_multinom`: Results from fitting a multinomial model/workflow to resamples (`3_fit_mn.R`)
- `fit_multinom_2`: Results from fitting a multinomial model/workflow to resamples (`3_fit_mn_2.R`)
- `tuned_rf`: Results from tuning random forest model/workflow on resamples (`3_tune_rf.R`)
- `tuned_rf_2`: Results from tuning andom forest model/workflow on resamples (`3_tune_rf_2.R`)
- `tuned_knn`: Results from tuning k-nearest neighbor model/workflow on resamples (`3_tune_knn.R`)
- `tuned_knn_2`: Results from tuning k-nearest neighbor model/workflow on resamples (`3_tune_knn_2.R`)
- `tuned_en`: Results from tuning elastic net model/workflow on resamples (`3_tune_en.R`)
- `tuned_en_2`: Results from tuning elastic net model/workflow on resamples (`3_tune_en_2.R`)
- `tuned_bt`: Results from tuning boosted tree model/workflow on resamples (`3_tune_bt.R`)
- `tuned_bt_2`: Results from tuning boosted tree model/workflow on resamples (`3_tune_bt_2.R`)
- `fit_null`: Results from fitting a null model/workflow on resamples (`3_fit_baseline.R`)
- `fit_nbayes`: Results from tuning a naive bayes model/workflow on resamples (`3_fit_baseline.R`)
- `final_fit_bt`: Results from fitting final boosted tree model/workflow on training data (`5_train_final_model.R`)
- `student_results`: Prediction results from the final boosted tree model and observed outcome values (`6_assess_final_model.R`)