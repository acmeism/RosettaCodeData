# syntax: GAWK -f ADDITIVE_PRIMES.AWK
BEGIN {
    start = 1
    stop = 500
    for (i=start; i<=stop; i++) {
      if (is_prime(i) && is_prime(sum_digits(i))) {
        printf("%4d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nAdditive primes %d-%d: %d\n",start,stop,count)
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
function sum_digits(n,  i,sum) {
    for (i=1; i<=length(n); i++) {
      sum += substr(n,i,1)
    }
    return(sum)
}
