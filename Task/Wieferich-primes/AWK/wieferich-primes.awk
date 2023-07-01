# syntax: GAWK -f WIEFERICH_PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    start = 1
    stop = 4999
    for (i=start; i<=stop; i++) {
      if (is_wieferich_prime(i)) {
        printf("%d\n",i)
        count++
      }
    }
    printf("Wieferich primes %d-%d: %d\n",start,stop,count)
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
function is_wieferich_prime(p,  p2,q) {
    if (!is_prime(p)) { return(0) }
    q = 1
    p2 = p^2
    while (p > 1) {
      q = (2*q) % p2
      p--
    }
    return(q == 1)
}
