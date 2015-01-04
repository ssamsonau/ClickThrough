prepareDT <- function(DT, use, factorLimitN){
  
  library(data.table)
  
  # removing variables which expected to introduce noise only
  # colToDelete <- c("id", "device_ip", "device_id", "device_model")
  colToDelete <- c("")
  
  
  #Wokring with date and Time
  #colToDelete <- c(colToDelete, "hour")
  DT[, onlyHour:=substr(DT$hour, 7, 8)]
  DT[, c("onlyDate", "hour"):=
       list(as.IDate( substr(DT$hour, 1, 6), format="%y%m%d"), NULL) ]
  DT[, c("weekDayN", "onlyDate"):=list(wday(onlyDate), NULL)]
  DT[, "dayType":= ifelse(weekDayN==7 | weekDayN == 1, "Weekend", "WorkDay")]  
  
  colToDelete <-c("")
  #levels of the outcome will be translated to DF coloumn names while predicting probabilities
  #- so they should not start from a number
  if("click" %in% names(DT)){ 
    DT[, .outcome := paste0("L", as.character(click))]
    colToDelete <- c(colToDelete, "click") #click was replaced by .outcome
  }  
  
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
  
  if(use=="manually_chosen") {
    matchNames <- names(DT) %in% c("banner_pos", "site_category", "app_category",
                                   "device_type", "device_conn_type", "onlyHour", "weekDayN", "dayType", 
                                   ".outcome")
    colToDelete <- names(DT)[!matchNames]
  }
  
  DT[, (colToDelete):= NULL]
  if("id" %in% names(DT)) DT[, id:=NULL]
  DT[, (names(DT)):= lapply(.SD, as.factor), .SDcols=names(DT)]
}

