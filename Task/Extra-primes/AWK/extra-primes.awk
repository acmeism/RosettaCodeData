# syntax: GAWK -f EXTRA_PRIMES.AWK
BEGIN {
    for (i=1; i<10000; i++) {
      if (is_prime(i)) {
        sum = fail = 0
        for (j=1; j<=length(i); j++) {
          sum += n = substr(i,j,1)
          if (!is_prime(n)) {
            fail = 1
            break
          }
        }
        if (is_prime(sum) && fail == 0) {
          printf("%2d %4d\n",++count,i)
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
