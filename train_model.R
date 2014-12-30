library(caret)
source("./prepareDT.R")

prepareDT(trainDT, "train")

source("myCustomClassSummary.R")

#trGrid <-  expand.grid(C=c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100, 300))
#trGrid <-  expand.grid(C=c(0.1, 1, 10))
trGrid <- expand.grid(size=c(7, 9, 11), decay=c(1e-3, 1e-1, 3e-1, 9e-1))

trainCt <- trainControl(
  method = "cv", number =2,
  summaryFunction = myCustomClassSummary, #multiClassSummary, ## Evaluate performance using the following function
  #summaryFunction = twoClassSummary,
  classProbs = TRUE,
  verbose=TRUE) 

print(str(trainDT))
mod <- train(.outcome ~ ., data=trainDT, 
             method=model.name,
             trControl=trainCt, 
             tuneGrid = trGrid,
             #metric = "ROC"
             metric="logLoss", maximize=FALSE,
             MaxNWts = 100000
             )
print(mod)

save(mod, file = paste0("model_", N_rows, "_", model.name, ".rda"))

#what is training error
library(Metrics)
print("training error Final: logLoss")
print(
  logLoss(  ifelse(mod$trainingData$.outcome =="L1", 1, 0), 
            mod$finalModel$fitted.values)
)

print("ROC curve")
library(ROCR)
#print( auc(response=mod$trainingData$.outcome, predictor=mod$finalModel$fitted.values)  )
pr <- prediction(mod$finalModel$fitted.values, mod$trainingData$.outcome)
plot(performance(pr, "tpr", "fpr"))
print("AUC is")
print( performance(pr, "auc")@y.values )


#determine which value can be used as average
# middle.value=seq(0.001, 1, by=0.001)
# y <- middle.value
# for(k in 1:length(middle.value))
#     y[k]=logLoss(  ifelse(mod$trainingData$.outcome =="L1", 1, 0), middle.value[k])
#     
# #plot(middle.value, y)
# which(min(y)==y)*0.001
