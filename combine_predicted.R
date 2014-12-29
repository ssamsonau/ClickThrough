
sub123 <- fread("submission_svmLinear_10000_Seed123.csv")
sub456 <- fread("submission_svmLinear_10000_Seed456.csv")

str(sub123[click==0.5,])
str(sub456[click==0.5,])

vectNotPredicted <- sub123[, click]==0.5
  
sub123[vectNotPredicted, click:=sub456[vectNotPredicted, click] ] 

str(sub123[click==0.5,])

write.table(format(combOut, scientific=FALSE), file="submission_comb.csv", quote=F, row.names=F, sep=",")
