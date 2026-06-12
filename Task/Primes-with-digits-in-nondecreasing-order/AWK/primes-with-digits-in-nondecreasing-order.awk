# syntax: GAWK -f PRIMES_WITH_DIGITS_IN_NONDECREASING_ORDER.AWK
BEGIN {
    start = 1
    stop = 1000
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        flag = 1
        for (j=1; j<length(i); j++) {
          if (substr(i,j,1) > substr(i,j+1,1)) {
            flag = 0
          }
        }
        if (flag == 1) {
          printf("%4d%1s",i,++count%10?"":"\n")
        }
      }
    }
    printf("\nPrimes with digits in nondecreasing order %d-%d: %d\n",start,stop,count)
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
