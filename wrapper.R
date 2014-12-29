file.path <- "E://Temp/Click-Through-Data/"
N_rows <- 50000
model.name <- "nnet"

UseParallel = FALSE
N.of.clusters <- 3 # Number of clusters for a parralel execution
if(UseParallel) source("useParallel.R")

set.seed(123)
#set.seed(456)

#Read ids
library(data.table)

if(!exists("vectIDs")){
  vectIDs <- fread(paste0(file.path, "trainIDs.csv"), colClasses="character")
  setnames(vectIDs, "V1", "id")
}

#sample to get train data
vectorChoose <- sample(vectIDs$id, N_rows)
vectorChooseSTR <- paste(vectorChoose, collapse="','")

#Read subset of the data from db
library(RSQLite)
con <- dbConnect("SQLite", dbname= paste0(file.path, "ClickTroughTrain.sqlite") )

trainDT <- data.table(
  dbGetQuery(con, paste0("SELECT * FROM trainTable WHERE id IN ('", vectorChooseSTR ,"') ;"))
)
dbDisconnect(con)


StartTime <- Sys.time()
source("train_model.R")
StopTime <- Sys.time()

print(StopTime - StartTime)

source("prediction.R")

if(UseParallel) stopCluster(workers)
