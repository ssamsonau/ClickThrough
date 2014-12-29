file.path <- "E://Temp/Click-Through-Data/"
N_rows <- 10000
model.name <- "svmLinear"

UseParallel = TRUE
N.of.clusters <- 3 # Number of clusters for a parralel execution
if(UseParallel) source("useParallel.R")

set.seed(123)

#Read ids
library(data.table)

if(!exists("vectIDs")){
  vectIDs <- fread(paste0(file.path, "trainIDs.csv"), colClasses="character")
  setnames(vectIDs, "V1", "id")
}


#Read subset of the data from db
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

StartTime <- Sys.time()
source("train_model.R")
StopTime <- Sys.time()

print(StopTime - StartTime)

source("prediction.R")

if(UseParallel) stopCluster(workers)
