# syntax: GAWK -f LARGEST_DIFFERENCE_BETWEEN_ADJACENT_PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    stop = 1000000
    champi = 3
    champj = 5
    i = 5
    record = 2
    while (i < stop) {
      j = next_prime(i)
      if (j-i > record) {
        champi = i
        champj = j
        record = j - i
      }
      i = j
    }
    printf("The largest difference between adjacent primes < %d is %d between %d and %d\n",stop,record,champi,champj)
    exit(0)
}
function next_prime(n,  q) { # finds the next prime after n
    if (n == 0) { return(2) }
    if (n < 3) { return(++n) }
    q = n + 2
    while (!is_prime(q)) {
      q += 2
    }
    return(q)
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
