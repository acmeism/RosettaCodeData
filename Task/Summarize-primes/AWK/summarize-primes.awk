# syntax: GAWK -f SUMMARIZE_PRIMES.AWK
BEGIN {
    start = 1
    stop = 999
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        count1++
        sum += i
        if (is_prime(sum)) {
          printf("the sum of %3d primes from primes 2-%-3s is %5d which is also prime\n",count1,i,sum)
          count2++
        }
      }
    }
    printf("Summarized primes %d-%d: %d\n",start,stop,count2)
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
