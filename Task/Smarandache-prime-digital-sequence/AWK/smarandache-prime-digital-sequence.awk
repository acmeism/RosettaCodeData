# syntax: GAWK -f SMARANDACHE_PRIME-DIGITAL_SEQUENCE.AWK
BEGIN {
    limit = 25
    printf("1-%d:",limit)
    while (1) {
      if (is_prime(++n)) {
        if (all_digits_prime(n) == 1) {
          if (++count <= limit) {
            printf(" %d",n)
          }
          if (count == 100) {
            printf("\n%d: %d\n",count,n)
            break
          }
        }
      }
    }
    exit(0)
}
function all_digits_prime(n, i) {
    for (i=1; i<=length(n); i++) {
      if (!is_prime(substr(n,i,1))) {
        return(0)
      }
    }
    return(1)
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
