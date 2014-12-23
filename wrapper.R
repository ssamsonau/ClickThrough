file.path <- "E://Temp/Click-Through-Data/"
N_rows <- 5000

UseParallel = TRUE
N.of.clusters <- 3 # Number of clusters for a parralel execution

set.seed(123)

if(UseParallel) source("useParallel.R")

library(data.table)

vectIDs <- fread(paste0(file.path, "trainIDs.csv"), colClasses="character")
setnames(vectIDs, "V1", "id")

library(RSQLite)
con <- dbConnect("SQLite", dbname= paste0(file.path, "ClickTroughTrain.sqlite") )

#sample to get train data
vectorChoose <- sample(vectIDs$id, N_rows)

vectorChooseSTR <- ""
for(val in vectorChoose){
  vectorChooseSTR <- paste0(vectorChooseSTR, "'", val, "', ")
}
vectorChooseSTR <- substr(vectorChooseSTR, 1, nchar(vectorChooseSTR)-2 )
trainDT <- data.table(
  dbGetQuery(con, paste0("SELECT * FROM trainTable WHERE id IN (", vectorChooseSTR ,") ;"))
)


dbDisconnect(con)


#trainDT <- fread(paste0(file.path, "train"), nrows = 100)  # 40428968 total # of rows
#trainDT <- fread(paste0(file.path, "train"))  # 40428968 total # of rows




StartTime <- Sys.time()

source("train_model.R")


StopTime <- Sys.time()

print(StopTime - StartTime)


source("prediction.R")

#combOut[, id:=as.character(id)]

write.table(format(combOut, scientific=FALSE), file="submission.csv", quote=F, row.names=F, sep=",")

if(UseParallel) stopCluster(workers)