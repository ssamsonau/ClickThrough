library(caret)
source("./prepareDT.R")

prepareDT(trainDT)

source("multiClassSummary.R")

trGrid <-  expand.grid(C=c(0.1, 0.3, 1, 3, 10, 100))

trainCt <- trainControl(
  method = "cv", number =2,
  summaryFunction = multiClassSummary, ## Evaluate performance using the following function
  classProbs = TRUE) 

mod <- train(.outcome ~ ., data=trainDT, 
             method=model.name,
             trControl=trainCt, tuneGrid = trGrid,
             metrics="logLoss")

print(mod)

save(mod, file = paste0("model_", N_rows, "_", model.name, ".rda"))
