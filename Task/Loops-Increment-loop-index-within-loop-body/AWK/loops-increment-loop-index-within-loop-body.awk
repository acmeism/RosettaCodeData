# syntax: GAWK -f LOOPS_INCREMENT_LOOP_INDEX_WITHIN_LOOP_BODY.AWK
BEGIN {
    limit = 42
    n = 0
    for (i=limit; n<limit; i++) {
      if (is_prime(i)) {
        printf("%2d %19'd\n",++n,i)
        i += i - 1
      }
    }
    exit(0)
}
function is_prime(n,  d) {
    if (n % 2 == 0) { return(n == 2) }
    if (n % 3 == 0) { return(n == 3) }
    d = 5
    while (d*d <= n) {
      if (n % d == 0) { return(0) }
      d += 2
      if (n % d == 0) { return(0) }
      d += 4
    }
    return(1)
}
