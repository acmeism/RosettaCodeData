# Antiprimes

max_divisors <- 0

findFactors <- function(x){
  myseq <- seq(x)
  myseq[(x %% myseq) == 0]
}

antiprimes <- vector()
x <- 1
n <- 1
while(length(antiprimes) < 20){
  y <- findFactors(x)
  if (length(y) > max_divisors){
    antiprimes <- c(antiprimes, x)
    max_divisors <- length(y)
    n <- n + 1
  }
  x <- x + 1
}

antiprimes
