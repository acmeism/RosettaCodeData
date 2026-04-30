# syntax: GAWK -f CUBAN_PRIMES.AWK
# converted from EasyLang
BEGIN {
    limit = 200
    printf("The first %d cuban primes are:\n",limit)
    while (count < 10000 ) {
      i++
      di = 3 * i * (i + 1) + 1
      if (is_prime(di) == 1) {
        if (++count <= limit) {
          printf("%8d%s",di,count%10?"":"\n")
        }
      }
    }
    printf("\ncuban prime # %d is: %'d\n",count,di)
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
