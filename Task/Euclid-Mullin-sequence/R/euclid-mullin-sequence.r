library(gmp)

next_term <- function(v) min(factorize(prod(v)+1))
euclid_mullin <- function(n){
  v <- as.bigz(2)
  replicate(n-1, v <<- c(v, next_term(v)))
  print(v, initLine=FALSE)
}

euclid_mullin(16)
