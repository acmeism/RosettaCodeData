library(gmp)

wilson <- function(p, n) factorialZ(n-1)*factorialZ(p-n)-(-1)^n
is_wilson <- function(p, n) denominator(as.bigq(wilson(p, n), p^2))==1
primes <- Filter(function(n) isprime(n)!=0, 1:11000)
wilsons <- lapply(1:11, function(n) Filter(function(p) is_wilson(p, n), primes))
for(i in 1:11) if(length(wilsons[[i]])==0) wilsons[[i]] <- "None"
print(wilsons, quote=FALSE)
