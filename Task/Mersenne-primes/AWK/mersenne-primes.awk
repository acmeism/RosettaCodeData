# syntax: GAWK --bignum -f MERSENNE_PRIMES.AWK
BEGIN {
    base = 2
    for (i=1; i<62; i++) {
      if (is_prime(base-1)) {
        printf("2 ^ %d - 1\n",i)
      }
      base *= 2
    }
    exit(0)
}
function is_prime(n,  d) {
    d = 5
    if (n < 2) { return(0) }
    if (n % 2 == 0) { return(n == 2) }
    if (n % 3 == 0) { return(n == 3) }
    while (d*d <= n) {
      if (n % d == 0) { return(0) }
      d += 2
      if (n % d == 0) { return(0) }
      d += 4
    }
    return(1)
}
