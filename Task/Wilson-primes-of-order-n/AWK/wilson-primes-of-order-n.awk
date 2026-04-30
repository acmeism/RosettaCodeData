# syntax: GAWK -f WILSON_PRIMES_OF_ORDER_N.AWK
# converted from FreeBASIC
#
# This excludes the trivial case p=n=2 as does:
# Ada, EasyLang, FreeBasic, FutureBasic, Maxima, PARI/GP
BEGIN {
    print(" n Wilson primes")
    print("-- -------------")
    for (n=1; n<=11; n++) {
      printf("%2d ",n)
      for (p=3; p<11000; p+=2) {
        if (is_prime(p)) {
          if (is_wilson_prime(n,p)) {
            printf(" %d",p)
          }
        }
      }
      printf("\n")
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
function is_wilson_prime(n,p,  i,prod,p2) {
    if (p < n) { return(0) }
    prod = 1
    p2 = p^2
    for (i=1; i<=n-1; i++) {
      prod = (prod*i) % p2
    }
    for (i=1; i<=p-n; i++) {
      prod = (prod*i) % p2
    }
    prod = (p2 + prod - (-1)^n) % p2
    return(prod == 0)
}
