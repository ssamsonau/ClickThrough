library(caret)
source("./prepareDT.R")

prepareDT(trainDT, "train")

source("myCustomClassSummary.R")

#trGrid <-  expand.grid(C=c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100, 300))
#trGrid <-  expand.grid(C=c(0.1, 1, 10))

trainCt <- trainControl(
  method = "cv", number =2,
  summaryFunction = myCustomClassSummary, #multiClassSummary, ## Evaluate performance using the following function
  classProbs = TRUE,
  verbose=TRUE) 

print(str(trainDT))
mod <- train(.outcome ~ ., data=trainDT, 
             method=model.name,
             trControl=trainCt, #tuneGrid = trGrid,
             metrics="logLoss", maximize=FALSE)

print(mod)

save(mod, file = paste0("model_", N_rows, "_", model.name, ".rda"))
