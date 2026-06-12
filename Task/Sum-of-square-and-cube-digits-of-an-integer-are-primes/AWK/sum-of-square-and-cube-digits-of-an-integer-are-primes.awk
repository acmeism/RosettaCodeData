# syntax: GAWK -f SUM_OF_SQUARE_AND_CUBE_DIGITS_OF_AN_INTEGER_ARE_PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    start = 1
    stop = 99
    for (i=start; i<=stop; i++) {
      if (is_prime(digit_sum(i^3,10)) && is_prime(digit_sum(i^2,10))) {
        printf("%5d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nSum of square and cube digits are prime %d-%d: %d\n",start,stop,count)
    exit(0)
}
function digit_sum(n,b,  s) { # digital sum of n in base b
    while (n) {
      s += n % b
      n = int(n/b)
    }
    return(s)
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
