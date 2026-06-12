# syntax: GAWK -f COUSIN_PRIMES.AWK
BEGIN {
    start = 1
    stop = 1000
    for (i=start; i<=stop; i++) {
      if (is_prime(i) && is_prime(i+4)) {
        printf("%3d:%3d%1s",i,i+4,++count%10?"":"\n")
      }
    }
    printf("\nCousin primes %d-%d: %d\n",start,stop,count)
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
