smallest_square <- function(n){
  k <- 1
  while(!startsWith(as.character(k^2), as.character(n))) k <- k+1
  c(k,k^2)
}

lapply(1:49, smallest_square)
