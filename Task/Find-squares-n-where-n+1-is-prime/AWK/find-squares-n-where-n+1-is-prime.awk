# syntax: GAWK -f FIND_SQUARES_N_WHERE_N+1_IS_PRIME.AWK
BEGIN {
    start = 1
    stop = 999
    n = 2
    n2 = n^2
    printf("1")
    count++
    while (n2 < stop) {
      if (is_prime(n2+1)) {
        printf(" %d",n2)
        count++
      }
      n += 2
      n2 = n^2
    }
    printf("\nFind squares %d-%d: %d\n",start,stop,count)
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
