# syntax: GAWK -f NEXT_SPECIAL_PRIMES.AWK
BEGIN {
    start = 1
    stop = 1050
    print("Prime1 Prime2 Gap")
    last_special = 3
    last_gap = 1
    printf("%6d %6d %3d\n",2,3,last_gap)
    count = 1
    for (i=start; i<=stop; i++) {
      if (is_prime(i) && i-last_special > last_gap) {
        last_gap = i - last_special
        printf("%6d %6d %3d\n",last_special,i,last_gap)
        last_special = i
        count++
      }
    }
    printf("Next special primes %d-%d: %d\n",start,stop,count)
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
