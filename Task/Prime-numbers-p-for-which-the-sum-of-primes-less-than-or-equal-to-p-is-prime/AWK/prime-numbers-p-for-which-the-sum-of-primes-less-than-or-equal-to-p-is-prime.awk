# syntax: GAWK -f PRIME_NUMBERS_P_WHICH_SUM_OF_PRIME_NUMBERS_LESS_OR_EQUAL_TO_P_IS_PRIME.AWK
BEGIN {
    start = 1
    stop = 999
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        sum += i
        if (is_prime(sum)) {
          printf("%4d%1s",i,++count%10?"":"\n")
        }
      }
    }
    printf("\n%d-%d: %d\n",start,stop,count)
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
