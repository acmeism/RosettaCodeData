x <- 1:100
xx <- as.character(x)
xx[x%%3==0] <- "Fizz"
xx[x%%5==0] <- "Buzz"
xx[x%%15==0] <- "FizzBuzz"
xx
