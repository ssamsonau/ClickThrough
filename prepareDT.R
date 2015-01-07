prepareDT <- function(DT, use, factorLimitN){
  
  library(data.table)

  if("id" %in% names(DT)) DT[, id:=NULL]

  colToDelete <- c("")
  
  
  #Wokring with date and Time
  #colToDelete <- c(colToDelete, "hour")
  DT[, onlyHour:=substr(DT$hour, 7, 8)]
  DT[, c("onlyDate", "hour"):=
       list(as.IDate( substr(DT$hour, 1, 6), format="%y%m%d"), NULL) ]
  DT[, c("weekDayN", "onlyDate"):=list(wday(onlyDate), NULL)]
  DT[, "dayType":= ifelse(weekDayN==7 | weekDayN == 1, "Weekend", "WorkDay")]  
  
  #add L to all values - so h2o converts all of them as factors
  add.L <- function(x) paste0("L", x)
  DT[, (names(DT)):=lapply(.SD, add.L), .SDcol=names(DT)]
  
  if(use == "train"){
    #Determine how many levels has every variable. If more than certain number - remove variable.
    #For each factor value a new dummy variable is created - too much variables and bad generalization.

    for(name in names(DT)){
      un <- unique(DT[, get(name)])
      if(length(un)>factorLimitN) colToDelete <- c(colToDelete, name)    
    }
  }
  
  if(use=="test") {
    #matchNames <- names(DT) %in% names(mod$trainingData)
    #colToDelete <- names(DT)[!matchNames]
  }

  
  DT[, (colToDelete):= NULL]
  #DT[, (names(DT)):= lapply(.SD, as.factor), .SDcols=names(DT)]
}

