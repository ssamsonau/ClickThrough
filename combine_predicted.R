library(data.table)
sub123 <- fread("submission_50000svmLinear.csv", colClasses=c(id="character"))
sub456 <- fread("submission_50000nnet_size_7to11.csv", colClasses=c(id="character"))

str(sub123[click==0.5,])
str(sub456[click==0.5,])

vPredict123 <- sub123[, click]!=0.5
vPredict456 <- sub456[, click]!=0.5  


sub123[!vPredict123 & vPredict456, click:=sub456[!vPredict123 & vPredict456, click] ] 
sub456[!vPredict456 & vPredict123, click:=sub123[!vPredict456 & vPredict123, click] ] 

subComb <- data.table(sub123)
subComb[, click:=(sub123[, click]+sub456[, click])/2]


str(subComb[click==0.5,])

write.table(format(subComb, scientific=FALSE), file="submission_comb.csv", quote=F, row.names=F, sep=",")
