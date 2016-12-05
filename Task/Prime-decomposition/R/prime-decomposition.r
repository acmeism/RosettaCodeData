findfactors <- function(num) {
  x <- c()
  1stprime<- 2; 2ndprime <- 3; everyprime <- num
  while( everyprime != 1 ) {
    while( everyprime%%1stprime == 0 ) {
      x <- c(x, 1stprime)
      everyprime <- floor(everyprime/ 1stprime)
    }
    1stprime <- 2ndprime
    2ndprime <- 2ndprime + 2
  }
  x
}

print(findfactors(1027*4))
