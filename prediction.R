gl.var <- ls() 
gl.var <- gl.var[! (gl.var %in% c("N_rows", "file.path", "vectIDs") )] 
rm( list =gl.var )
 
library(data.table)

load(paste0("model_", N_rows, "_RF.rda"))

testDT <- fread(paste0(file.path, "test"), colClasses=c(id="character"))

combOut <- subset(testDT, select=id)
combOut[,click:=c(2)] #click coloumn for probability of click (this name should be submitted)

library(caret)
source("prepareDT.R")
prepareDT(testDT)

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

sliceVect <- rep(FALSE, s.T.size)

N_chunks = 100
for(chunk in 1:N_chunks){
  sliceVect[((chunk-1)*s.T.size/N_chunks):(chunk*s.T.size/N_chunks)] <- TRUE
  
  print(table(sliceVect))
  print(chunk)
  print(range(which(sliceVect)))
  
  out[matchT][sliceVect] <- predict(mod, newdata=subtestDT[sliceVect, ], type="prob")$L1

  sliceVect[sliceVect] <- FALSE
}
 
combOut[matchT, click:= out[matchT]]

combOut[click==2, click:=0.5] 

summary(combOut)
