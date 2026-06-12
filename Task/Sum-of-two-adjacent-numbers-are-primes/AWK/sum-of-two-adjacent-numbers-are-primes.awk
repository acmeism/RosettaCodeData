# syntax: GAWK -f SUM_OF_TWO_ADJACENT_NUMBERS_ARE_PRIMES.AWK
BEGIN {
    n = 1
    stop = 20
    printf("The first %d pairs of numbers whose sum is prime:\n",stop)
    while (count < stop) {
      if (is_prime(2*n + 1)) {
        printf("%2d + %2d = %2d\n",n,n+1,2*n+1)
        count++
      }
      n++
    }
    exit(0)
}
function is_prime(n,  d) {
    d = 5
    if (n < 2) { return(0) }
    if (n % 2 == 0) { return(n == 2) }
    if (n % 3 == 0) { return(n == 3) }
    while (d*d <= n) {
      if (n % d == 0) { return(0) }
      d += 2
      if (n % d == 0) { return(0) }
      d += 4
    }
    return(1)
}
