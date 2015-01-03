library(data.table)
subSmall <- fread("submission_50000nnet_size_7to11_manual.csv", colClasses=c(id="character"))
subLarge <- fread("submission_50000nnet_size_7to11.csv", colClasses=c(id="character"))

str(subSmall[click==0.5,])
str(subLarge[click==0.5,])

replaceVect <- subLarge$click==0.5
 
subLarge[replaceVect, click:=subSmall[replaceVect, click]] 

str(subLarge[click==0.5,])

write.table(format(subLarge, scientific=FALSE), file="submission_comb.csv", quote=F, row.names=F, sep=",")
