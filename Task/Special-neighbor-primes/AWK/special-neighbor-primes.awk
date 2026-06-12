# syntax: GAWK -f SPECIAL_NEIGHBOR_PRIMES.AWK
BEGIN {
    start = 3
    stop = 99
    old_prime = 2
    for (n=start; n<=stop; n++) {
      if (is_prime(n) && is_prime(old_prime)) {
        sum = old_prime + n - 1
        if (is_prime(sum)) {
          count++
          printf("%d,%d -> %d\n",old_prime,n,sum)
        }
        old_prime = n
      }
    }
    printf("Special neighbor primes %d-%d: %d\n",start,stop,count)
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
