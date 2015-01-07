library(data.table)

vectIDs <- fread(paste0(file.path, "trainIDs.csv"), colClasses="character")
setnames(vectIDs, "V1", "id")

set.seed(123)

shuffledID <- sample(vectIDs$id, length(vectIDs$id))

write.table(shuffledID, file=paste0(file.path, "shuffledID.csv"), quote=F, row.names=F)
