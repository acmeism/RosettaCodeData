# syntax: GAWK -f WAGSTAFF_PRIMES.AWK
BEGIN {
    p = 1
    while (count < 10) {
      p += 2
      if (is_prime(p)) {
        w = (2^p+1) / 3
        if (is_prime(w)) {
          printf("%2d: %3d %14d\n",++count,p,w)
        }
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
