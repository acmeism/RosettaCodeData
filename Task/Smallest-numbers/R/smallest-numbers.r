library(gmp)

smallest_selfexp <- function(n){
  k <- 1
  selfexp <- function(k) as.character(as.bigz(k)^k)
  while(!grepl(as.character(n), selfexp(k))) k <- k+1
  sprintf("%i: %i^%i = %s", n, k, k, selfexp(k))
}

writeLines(sapply(0:50, smallest_selfexp))
