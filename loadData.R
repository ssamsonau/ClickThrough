file.path <- "E://Temp/Click-Through-Data/train"

UseParallel = FALSE

if(UseParallel){
  N.of.clusters <- 3 # Number of clusters for a parralel execution
  
  #library(Revobase);   setMKLthreads(4)
  #parallel processing to be used in caret::train
  library(foreach); library(doParallel)
  if(exists("workers")) stopCluster(workers)
  workers <- makeCluster(N.of.clusters);  registerDoParallel(workers)
  
}



library(data.table)

DT <- fread(file.path, nrows = 200)

  # removing variables which expected to introduce noice only
colToDelete <- c("id", "device_ip", "device_id", "device_model")

  # remove hour coloumn for now - when using only small part of data
colToDelete <- c(colToDelete, "hour")

  #levels of the outcome will be translated to DF coloumn names while predicting probabilities
  #- so they should not start from a number
DT[, click := paste0("L", as.character(click))]

DT[, (colToDelete):= NULL]

DTcol <- names(DT)
DT[, (DTcol):= lapply(.SD, as.factor), .SDcols=DTcol]
str(DT)


library(caret)

trainCt <- trainControl(method = "boot", 
                        number = 10,
                        classProbs=TRUE,
                        summaryFunction=twoClassSummary, 
                        verboseIter=TRUE,
                        allowParallel=UseParallel)

mod <- train(click ~ ., data=DT, 
             method="rf",
             trControl=trainCt, metric="ROC")
mod

predOut <- predict(mod, newdata=DT)
print(predOut)

if(UseParallel) stopCluster(workers)
