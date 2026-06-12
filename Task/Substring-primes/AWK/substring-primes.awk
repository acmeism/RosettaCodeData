# syntax: GAWK -f SUBSTRING_PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    start = 1
    stop = 500
    for (i=start; i<=stop; i++) {
      if (is_substring_prime(i)) {
        printf("%d ",i)
        count++
      }
    }
    printf("\nSubString Primes %d-%d: %d\n",start,stop,count)
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
function is_substring_prime(n) {
    if (!is_prime(i)) { return(0) }
    if (n < 10) { return(1) }
    if (!is_prime(n%100)) { return(0) }
    if (!is_prime(n%10)) { return(0) }
    if (!is_prime(int(n/10))) { return(0) }
    if (n < 100) { return(1) }
    if (!is_prime(int(n/100))) { return(0) }
    if (!is_prime(int((n%100)/10))) { return(0) }
    return(1)
}
