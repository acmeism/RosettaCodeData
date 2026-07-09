# syntax: GAWK -f DOUBLE_TWIN_PRIMES.AWK
# converted from EasyLang
BEGIN {
    for (n=3; n<=991; n+=2) {
      if (is_prime(n) == 1 && is_prime(n+2) == 1 && is_prime(n+6) == 1 && is_prime(n+8) == 1) {
        printf("%4d %4d %4d %4d\n",n,n+2,n+6,n+8)
      }
    }
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
