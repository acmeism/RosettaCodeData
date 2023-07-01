# syntax: GAWK -f SEQUENCE_OF_PRIMES_BY_TRIAL_DIVISION.AWK
BEGIN {
    low = 1
    high = 100
    for (i=low; i<=high; i++) {
      if (is_prime(i) == 1) {
        printf("%d ",i)
        count++
      }
    }
    printf("\n%d prime numbers found in range %d-%d\n",count,low,high)
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
