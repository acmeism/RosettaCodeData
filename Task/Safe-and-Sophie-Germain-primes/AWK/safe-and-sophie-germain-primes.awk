# syntax: GAWK -f SAFE_AND_SOPHIE_GERMAIN_PRIMES.AWK
BEGIN {
    limit = 50
    printf("The first %d Sophie Germain primes:\n",limit)
    while (count < limit) {
      if (is_prime(++i)) {
        if (is_prime(i+i+1)) {
          printf("%5d%1s",i,++count%10?"":"\n")
        }
      }
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
