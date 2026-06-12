# syntax: GAWK -f FIRST_9_PRIME_FIBONACCI_NUMBER.AWK
BEGIN {
    f1 = f2 = 1
    stop = 9
    printf("First %d Prime Fibonacci numbers:\n",stop)
    while (count < stop) {
      f3 = f1 + f2
      if (is_prime(f3)) {
        printf("%d ",f3)
        count++
      }
      f1 = f2
      f2 = f3
    }
    printf("\n")
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
