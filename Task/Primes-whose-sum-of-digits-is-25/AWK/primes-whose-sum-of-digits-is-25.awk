# syntax: GAWK -f PRIMES_WHICH_SUM_OF_DIGITS_IS_25.AWK
BEGIN {
    start = 1
    stop = 5000
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        sum = 0
        for (j=1; j<=length(i); j++) {
          sum += substr(i,j,1)
        }
        if (sum == 25) {
          printf("%d ",i)
          count++
        }
      }
    }
    printf("\nPrime numbers %d-%d whose digits sum to 25: %d\n",start,stop,count)
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
