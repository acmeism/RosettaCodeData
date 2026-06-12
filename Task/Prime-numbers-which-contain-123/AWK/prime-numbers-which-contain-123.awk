# syntax: GAWK -f PRIME_NUMBERS_WHICH_CONTAIN_123.AWK
BEGIN {
    start = 1
    stop = 99999
    for (i=start; i<=stop; i++) {
      if (is_prime(i) && i ~ /123/) {
        printf("%6d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nPrimes with '123' %d-%d: %d\n",start,stop,count)
    stop = 999999
    for (i=100000; i<=stop; i++) {
      if (is_prime(i) && i ~ /123/) {
        count++
      }
    }
    printf("\nPrimes with '123' %d-%d: %d\n",start,stop,count)
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
