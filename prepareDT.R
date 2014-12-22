prepareDT <- function(DT){
  
  library(data.table)
  
  # removing variables which expected to introduce noice only
  colToDelete <- c("id", "device_ip", "device_id", "device_model")
  
  # remove hour coloumn for now - when using only small part of data
  colToDelete <- c(colToDelete, "hour")

  #levels of the outcome will be translated to DF coloumn names while predicting probabilities
  #- so they should not start from a number
  if("click" %in% names(DT))
    DT[, click := paste0("L", as.character(click))]
  
  
  DT[, (colToDelete):= NULL]
  
  DTcol <- names(DT)
  
  
  DT[, (DTcol):= lapply(.SD, as.factor), .SDcols=DTcol]
  #DT[, (DTcol):= lapply(.SD, as.character), .SDcols=DTcol]
}


#   need to save factor levels before subsettings somehow...