# syntax: GAWK -f CIRCULAR_PRIMES.AWK
BEGIN {
    p = 2
    printf("first 19 circular primes:")
    for (count=0; count<19; p++) {
      if (is_circular_prime(p)) {
        printf(" %d",p)
        count++
      }
    }
    printf("\n")
    exit(0)
}
function cycle(n,  m,p) { # E.G. if n = 1234 returns 2341
    m = n
    p = 1
    while (m >= 10) {
      p *= 10
      m /= 10
    }
    return int(m+10*(n%p))
}
function is_circular_prime(p,  p2) {
    if (!is_prime(p)) {
      return(0)
    }
    p2 = cycle(p)
    while (p2 != p) {
      if (p2 < p || !is_prime(p2)) {
        return(0)
      }
      p2 = cycle(p2)
    }
    return(1)
}
function is_prime(x,  i) {
    if (x <= 1) {
      return(0)
    }
    for (i=2; i<=int(sqrt(x)); i++) {
      if (x % i == 0) {
        return(0)
      }
    }
    return(1)
}
