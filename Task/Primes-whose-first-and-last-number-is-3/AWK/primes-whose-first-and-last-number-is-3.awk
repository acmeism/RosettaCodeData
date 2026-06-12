# syntax: GAWK -f PRIMES_WHOSE_FIRST_AND_LAST_NUMBER_IS_3.AWK
BEGIN {
    start = 1
    stop = 3999
    for (i=start; i<=stop; i++) {
      if (is_prime(i) && i ~ /^3/ && i ~ /3$/) {
        printf("%5d%1s",i,++count1%10?"":"\n")
      }
    }
    printf("\nPrimes beginning and ending with '3' %d-%d: %d\n",start,stop,count1)
    start = 1
    stop = 999999
    for (i=start; i<=stop; i++) {
      if (is_prime(i) && i ~ /^3/ && i ~ /3$/) {
        count2++
      }
    }
    printf("Primes beginning and ending with '3' %d-%d: %d\n",start,stop,count2)
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
