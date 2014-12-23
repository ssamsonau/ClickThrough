library(caret)
source("./prepareDT.R")

prepareDT(trainDT)


#lev <- lapply(trainDT, levels)

#trainDT <- trainDT[sample(1:nrow(trainDT), N_rows), ]

source("multiClassSummary.R")

#trGrid <-  expand.grid(mtry=c(2))

trainCt <- trainControl(
  method = "cv", number =2,
  summaryFunction = multiClassSummary, ## Evaluate performance using the following function
  classProbs = TRUE) 

mod <- train(.outcome ~ ., data=trainDT, 
             method="rf",
             trControl=trainCt, #tuneGrid = trGrid,
             metrics="logLoss")

print(mod)

save(mod, file = paste0("model_", N_rows, "_RF.rda"))

#predOut <- predict(mod, newdata=trainDT)
#print(predOut)