sieve <- function(n) {
  if (n < 2) integer(0)
  else {
    primes <- rep(T, n)
    primes[[1]] <- F
    for(i in seq(sqrt(n))) {
      if(primes[[i]]) {
        primes[seq(i * i, n, i)] <- F
      }
    }
    which(primes)
  }
}

sieve(1000)
