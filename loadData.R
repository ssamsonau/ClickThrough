file.path <- "E://Temp/Click-Through-Data/train"

library(data.table)

DT <- fread(file.path, nrows = 100)

  # removing variables which expected to introduce noice only
colToDelete <- c("id", "device_ip", "device_id", "device_model")

  # remove hour coloumn for now - when using only small part of data
colToDelete <- c(colToDelete, "hour")

DT <- DT[, (colToDelete):= NULL]

DTcol <- names(DT)
DT <- DT[, (DTcol):= lapply(.SD, as.factor), .SDcols=DTcol]
str(DT)


library(caret)

trainCt <- trainControl(method = "boot", 
                        number = 10,
                        classProbs=TRUE,
                        summaryFunction=twoClassSummary)

mod <- train(click ~ ., data=DT, trControl=trainCt, metric="ROC")
mod

predOut <- predict(mod, newdata=DT)
print(predOut)
