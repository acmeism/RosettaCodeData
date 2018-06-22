# vectorized approach based on scalar code from primeSieve and mersenne in CRAN package `numbers`
require(gmp)
n <- 4423  # note that the sieve below assumes n > 9

# sieve the set of primes up to n
p <- seq(1, n, by = 2)
q <- length(p)
p[1] <- 2
for (k in seq(3, sqrt(n), by = 2))
  if (p[(k + 1)/2] != 0)
    p[seq((k * k + 1)/2, q, by = k)] <- 0
p <- p[p > 0]
cat(p[1]," special case M2 == 3\n")
p <- p[-1]

z2 <- gmp::as.bigz(2)
z4 <- z2 * z2
zp <- gmp::as.bigz(p)
zmp <- z2^zp - 1
S <- rep(z4, length(p))

for (i in 1:(p[length(p)] - 2)){
  S <- gmp::mod.bigz(S * S - z2, zmp)
  if( i+2 == p[1] ){
    if( S[1] == 0 ){
      cat( p[1], "\n")
      flush.console()
    }
    p <-  p[-1]
    zmp <- zmp[-1]
    S <-  S[-1]
  }
}
