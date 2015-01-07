#gl.var <- ls() 
#gl.var <- gl.var[! (gl.var %in% c("N_rows", "file.path", "vectIDs", "model.name", "workers", "UseParallel") )] 
#rm( list =gl.var )

library(data.table)

#model <- h2o.loadModel(localH2O, paste0("model_h2o_", model.name, "_lim", limitFactors, ".rda"))

testDT <- fread(paste0(file.path, "test"), colClasses=rep("character", 23))
combOut <- subset(testDT, select=id)
source("prepareDT.R")
prepareDT(testDT, "train", limitFactors)

library(h2o)
testDT.h2o <- as.h2o(client = localH2O, testDT, header=T)


combOut[,click:=c(2)] #click coloumn for probability of click (this name should be submitted)


print("making a prediction...")

predictedTest <- h2o.predict(best_model, testDT.h2o)

combOut[, click:= ( as.data.frame(predictedTest) )$L1]


summary(combOut)

file.remove("submission.csv")
write.table(format(combOut, scientific=FALSE), file="submission.csv", quote=F, row.names=F, sep=",")
