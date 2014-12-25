#Modified by me based on multiClassSummary.R

#Multi-Class Summary Function
#Based on caret:::twoClassSummary
# From: http://moderntoolmaking.blogspot.com/2012/07/error-metrics-for-multi-class-problems.html

# RES: disable compilation for debugging
# require(compiler)
# multiClassSummary <- cmpfun(function (data, lev = NULL, model = NULL){
myCustomClassSummary <- function (data, lev = NULL, model = NULL){
  
  #Check data
  if (!all(levels(data[, "pred"]) == levels(data[, "obs"]))) 
    stop("levels of observed and predicted data do not match")
  
  pred <- ifelse(data[, "pred"] == "L1", 1, 0)
  actual  <- ifelse(data[,  "obs"] == "L1", 1, 0)
  pred_prob <- data[,"L1"]
  
  #print(str(data))
  
  library(Metrics)
  
  out <- logLoss(actual, pred_prob)
  
  names(out) <- c("logLoss")
  
  out
  
}

