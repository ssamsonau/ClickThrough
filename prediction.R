gl.var <- ls() 
gl.var <- gl.var[! (gl.var %in% c("N_rows", "file.path", "vectIDs", "model.name", "workers", "UseParallel") )] 
rm( list =gl.var )
 
library(data.table)

#load(paste0("model_", N_rows, "_", model.name, "_lim", limitFactors, ".rda"))
load(paste0("model_", N_rows, "_", model.name, "_lim", limitFactors, "_manuallyChosen.rda"))

#what is training error
library(Metrics)
logLoss(  
  ifelse(mod$trainingData$.outcome =="L1", 1, 0), 
  mod$finalModel$fitted.values)

testDT <- fread(paste0(file.path, "test"), colClasses=c(id="character"))

combOut <- subset(testDT, select=id)
combOut[,click:=c(2)] #click coloumn for probability of click (this name should be submitted)

library(caret)
source("prepareDT.R")
prepareDT(testDT, "test", limitFactors)

T.size <- nrow(testDT)

matchT <- rep(TRUE, T.size)

for(col in names(testDT)){
  lev <- unlist(mod$xlevels[col])
  match <- testDT[, get(col)] %in% lev
  matchT <- matchT & match
}

out <- rep(2, T.size)

subtestDT <- testDT[matchT]
rm(testDT)
s.T.size  <- nrow(subtestDT)


N_chunks = 50
slice <- data.table(subNumber=c(1:s.T.size))
slice[, chunk:=subNumber%/%(.N%/%N_chunks)]

for(chunkN in 0:N_chunks){
#foreach(chunkN=0:N_chunks) %dopar% {
  print(chunkN)
  out[matchT][slice[chunk==chunkN, subNumber]] <- 
    caret::predict.train(mod, newdata=subtestDT[slice[chunk==chunkN, subNumber], ], type="prob")$L1
  print(out[matchT][1:10])
}
 
combOut[matchT, click:= out[matchT]]

combOut[click==2, click:=0.169] 

summary(combOut)

file.remove("submission.csv")
write.table(format(combOut, scientific=FALSE), file="submission.csv", quote=F, row.names=F, sep=",")
