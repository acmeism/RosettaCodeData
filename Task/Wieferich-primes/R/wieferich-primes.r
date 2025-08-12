library(gmp)

is_wieferich <- function(p){
  p_big <- as.bigz(p)
  (2^(p_big-1)-1)%%(p_big^2)==0
}

primes <- which(isprime(1:5000)!=0)

primes[is_wieferich(primes)]
