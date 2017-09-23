sieve <- function(n) {
  if (n < 2) return(NULL)
  a <- rep(T, n)
  a[1] <- F
  for(i in seq(n)) {
    if (a[i]) {
      j <- i * i
      if (j > n) return(which(a))
      a[seq(j, n, by=i)] <- F
    }
  }
}

sieve(1000)
