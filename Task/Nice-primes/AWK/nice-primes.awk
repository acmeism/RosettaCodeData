# syntax: GAWK -f NICE_PRIMES.AWK
BEGIN {
    start = 500
    stop = 1000
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        s = i
        while (s >= 10) {
          s = sum_digits(s)
        }
        if (s ~ /^[2357]$/) {
          count++
          printf("%d %d\n",i,s)
        }
      }
    }
    printf("Nice primes %d-%d: %d\n",start,stop,count)
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
function sum_digits(x,  sum,y) {
    while (x) {
      y = x % 10
      sum += y
      x = int(x/10)
    }
    return(sum)
}
