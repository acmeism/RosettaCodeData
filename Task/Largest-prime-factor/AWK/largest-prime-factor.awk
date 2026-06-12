# syntax: GAWK -f LARGEST_PRIME_FACTOR.AWK
# converted from FreeBASIC
BEGIN {
    N = n = "600851475143"
    j = 3
    while (!is_prime(n)) {
      if (n % j == 0) {
        n /= j
      }
      j += 2
    }
    printf("The largest prime factor of %s is %d\n",N,n)
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
