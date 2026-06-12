library(gmp)

h_n2 <- function(n) Reduce(`+`, 1/as.bigz(1:n)^2)
wolstenholme <- function(n) numerator(h_n2(n))
wols <- sapply(1:20, wolstenholme)
wols_primes <- wols[sapply(wols, isprime)!=0]

print(wols, initLine=FALSE)
print(wols_primes, initLine=FALSE)
