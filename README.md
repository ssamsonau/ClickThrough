# Click-Through Rate Prediction

## neural network (from caret package) used for learning

[Click-Through Rate Prediction](https://www.kaggle.com/c/avazu-ctr-prediction) hosted by [Kaggle](https://www.kaggle.com/)

The goal is to predict whether a mobile ad will be clicked

Files:

* wrapper.R - contains "general" script calling to all other parts. Only subset of data is used (in order to be able to run on a regular desktop). (To load only subset of the data faster, cvs file was converted to SQLlite).
* prepareDT.R - formats the data, creates additional features, removes data with too many factors (in order to be able to run on a regular desktop)
* train_model.R - train model using neural network
* myCustomClassSummary.R - used for custom metrics in training algorithm
* useParallel.R - script used when Parallel execution needed. 
* prediction.R - do prediction. Fields without prediction (due to the limited amount of data used to train a model) filled with most probable value.