# syntax: GAWK -f PRIMES_A050921.AWK
# converted from FreeBASIC
BEGIN {
    print(" N  M Prime")
    for (n=1; n<=45; n++) {
      m = 0
      while (1) {
        p = n * (2 ^ m) + 1
        if (is_prime(p)) {
          printf("%2d %2d %5d\n",n,m,p)
          break
        }
        m++
      }
    }
    exit(0)
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
