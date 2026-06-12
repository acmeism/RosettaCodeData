# syntax: GAWK -f FIND_ADJACENTS_PRIMES_WHICH_DIFFERENCE_IS_SQUARE_INTEGER.AWK
# converted from FreeBASIC
BEGIN {
    start = i = 3
    stop =  999999
    while (j <= stop) {
      j = next_prime(i)
      if (j-i > 36 && is_square(j-i)) {
        printf("%9d %9d %9d\n",i,j,j-i)
        count++
      }
      i = j
    }
    printf("Adjacent primes which difference is square integer (>36) %d-%d: %d\n",start,stop,count)
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
function is_square(n) {
    return (int(sqrt(n))^2 == n)
}
function next_prime(n,  q) { # finds next prime after n
    if (n == 0) { return(2) }
    if (n < 3) { return(++n) }
    q = n + 2
    while (!is_prime(q)) {
      q += 2
    }
    return(q)
}
