# Click-Through Rate Prediction

## Deep learning (from h2o package) used for learning

[Click-Through Rate Prediction](https://www.kaggle.com/c/avazu-ctr-prediction) hosted by [Kaggle](https://www.kaggle.com/)

The goal is to predict whether a mobile ad will be clicked

Files:

* wrapper.R - contains "general" script calling to all other parts. Only subset of data is used (in order to be able to run on a regular desktop)
* prepareDT.R - formats the data, creates additional features, removes data with too many factors (in order to be able to run on a regular desktop)
* h2o.R - create learning model, using deep learning algorithm implemented in h2o package
* h2o_predict.R - use build model make a prediction.
