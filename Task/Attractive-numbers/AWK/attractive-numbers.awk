# syntax: GAWK -f ATTRACTIVE_NUMBERS.AWK
# converted from C
BEGIN {
    limit = 120
    printf("attractive numbers from 1-%d:\n",limit)
    for (i=1; i<=limit; i++) {
      n = count_prime_factors(i)
      if (is_prime(n)) {
        printf("%d ",i)
      }
    }
    printf("\n")
    exit(0)
}
function count_prime_factors(n,  count,f) {
    f = 2
    if (n == 1) { return(0) }
    if (is_prime(n)) { return(1) }
    while (1) {
      if (!(n % f)) {
        count++
        n /= f
        if (n == 1) { return(count) }
        if (is_prime(n)) { f = n }
      }
      else if (f >= 3) { f += 2 }
      else { f = 3 }
    }
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
