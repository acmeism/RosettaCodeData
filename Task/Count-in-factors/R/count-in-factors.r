#initially I created a function which returns prime factors then I have created another function counts in the factors and #prints the values.

findfactors <- function(num) {
  x <- c()
  p1<- 2
  p2 <- 3
  everyprime <- num
  while( everyprime != 1 ) {
    while( everyprime%%p1 == 0 ) {
      x <- c(x, p1)
      everyprime <- floor(everyprime/ p1)
    }
    p1 <- p2
    p2 <- p2 + 2
  }
  x
}
count_in_factors=function(x){
  primes=findfactors(x)
  x=c(1)
  for (i in 1:length(primes)) {
    x=paste(primes[i],"x",x)
  }
  return(x)
}
count_in_factors(72)
