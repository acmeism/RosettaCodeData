xx <- rep("", 100)
x <- 1:100
xx[x %% 3 == 0] <- paste0(xx[x %% 3 == 0], "Fizz")
xx[x %% 5 == 0] <- paste0(xx[x %% 5 == 0], "Buzz")
xx[xx == ""] <- x[xx == ""]
xx
