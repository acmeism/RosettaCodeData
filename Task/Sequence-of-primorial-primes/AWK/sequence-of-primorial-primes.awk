# syntax: GAWK -f SEQUENCE_OF_PRIMORIAL_PRIMES.AWK
# converted from Julia
BEGIN {
    n = 8
    printf("The first %d primorial indices sequentially producing primorial primes are: 1",n)
    primorial = 1
    count = 1
    p = 3
    prod = 2
    while (1) {
      if (is_prime(p)) {
        prod *= p
        primorial++
        if (is_prime(prod+1) || is_prime(prod-1)) {
          printf(" %d",primorial)
          if (++count == n) {
            break
          }
        }
      }
      p += 2
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
