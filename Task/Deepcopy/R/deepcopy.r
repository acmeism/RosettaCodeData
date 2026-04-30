a <- list(matrix(1:4, 2, 2), women, list(month.abb, pi), exp)
b <- a
b[[3]][[2]][1] <- 3.2
print(a)
print(b)
