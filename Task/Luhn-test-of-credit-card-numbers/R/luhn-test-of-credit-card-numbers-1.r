luhnTest <- function(cc){
  # Reverse the digits, convert to numeric vector
  cc2 <- as.numeric(unlist(strsplit(as.character(cc), "")))[nchar(cc):1]

  s1 <- 0
  s2 <- 0

  for (index in 1:length(cc2)){
    if (index %% 2 == 1){
      s1 <- sum(s1, cc2[index])
    } else if (cc2[index] >= 5){
      s2 <- sum(s2, (cc2[index]*2 - 9))
    } else {
      s2 <- sum(s2, (cc2[index]*2))
    }
  }

  return ((s1 + s2) %% 10 == 0)
}
