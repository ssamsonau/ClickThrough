mylogLoss <- function(actual, predicted_prob){
  
  #print(actual)
  #print(predicted_prob)
  score <- -(actual*log(predicted_prob) + (1-actual)*log(1-predicted_prob))
  score[actual==predicted_prob] <- 0
  score[is.nan(score)] <- Inf
  mean(score)
}