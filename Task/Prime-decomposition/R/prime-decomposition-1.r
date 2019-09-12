findfactors <- function(num) {
  x <- NULL
  firstprime<- 2; secondprime <- 3; everyprime <- num
  while( everyprime != 1 ) {
    while( everyprime%%firstprime == 0 ) {
      x <- c(x, firstprime)
      everyprime <- floor(everyprime/ firstprime)
    }
    firstprime <- secondprime
    secondprime <- secondprime + 2
  }
  x
}

print(findfactors(1027*4))
