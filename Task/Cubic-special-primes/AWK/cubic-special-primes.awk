# syntax: GAWK -f CUBIC_SPECIAL_PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    start = p = 2
    stop = 15000
    n = 1
    printf("%5d ",p)
    count = 1
    do {
      if (is_prime(p + n^3)) {
        p += n^3
        n = 1
        printf("%5d%1s",p,++count%10?"":"\n")
      }
      else {
        n++
      }
    } while (p + n^3 <= stop)
    printf("\nCubic special primes %d-%d: %d\n",start,stop,count)
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
