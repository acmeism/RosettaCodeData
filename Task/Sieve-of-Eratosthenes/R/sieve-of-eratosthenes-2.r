sieve <- function(n) {
  if (n < 2) return(integer(0))
  lmt <- (sqrt(n) - 1) / 2
  sz <- (n - 1) / 2
  buf <- rep(TRUE, sz)
  for(i in seq(lmt)) {
    if (buf[i]) {
      buf[seq((i + i) * (i + 1), sz, by=(i + i + 1))] <- FALSE
    }
  }
  cat(2, sep='')
  for(i in seq(sz)) {
    if (buf[i]) {
      cat(" ", (i + i + 1), sep='')
    }
  }
}

sieve(1000)
