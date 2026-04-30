library(gmp)

fermat <- function(n) 1+2^(2^as.bigz(n))
print(fermat(0:9), initLine=FALSE)
print(lapply(fermat(0:7), factorize), initLine=FALSE)
