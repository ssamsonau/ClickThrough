file.path <- "./data/"
N_rows <- 1e5
model.name <- "h2oDeep"
limitFactors <- 200

source("install.R")

set.seed(123)
library(data.table)

#read only these variables
select.names <- c("click", "C1", "banner_pos", "site_category", "app_domain", "app_category", 
                  "device_type", "device_conn_type", "C15", "C16", "C17", "C18", "C19", 
                  "C21", "hour")
#C20 has many NAs
#other rows have many factors...
file.names <- names( fread(paste0(file.path, "train"), nrows=1, colClasses = rep("character", 24)) )

trainDT <- fread(paste0(file.path, "train"),  
                 colClasses = rep("character", 24),
                 #na.strings="-1",
                 select = which(file.names %in% select.names) )

trainDT <-  trainDT[sample(1:40428967, 1e6), ]

source("h2o.R")
source("h2o_predict.R")
