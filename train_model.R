library(caret)
source("./prepareDT.R")

prepareDT(trainDT)

#lev <- lapply(trainDT, levels)

#trainDT <- trainDT[sample(1:nrow(trainDT), N_rows), ]

str(trainDT)



trainCt <- trainControl(method = "boot", 
                        number = 10,
                        classProbs=TRUE,
                        summaryFunction=twoClassSummary, 
                        verboseIter=TRUE,
                        allowParallel=UseParallel)

mod <- train(click ~ ., data=trainDT, 
             method="rf",
             trControl=trainCt, metric="ROC")
mod

save(mod, file = paste0("model_", N_rows, "_RF.rda"))

predOut <- predict(mod, newdata=trainDT)
print(predOut)