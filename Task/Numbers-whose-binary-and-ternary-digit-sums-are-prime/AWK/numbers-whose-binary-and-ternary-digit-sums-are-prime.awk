# syntax: GAWK -f NUMBERS_WHICH_BINARY_AND_TERNARY_DIGIT_SUM_ARE_PRIME.AWK
# converted from C
BEGIN {
    start = 0
    stop = 199
    for (i=start; i<=stop; i++) {
      if (is_prime(sum_digits(i,2)) && is_prime(sum_digits(i,3))) {
        printf("%4d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nBinary and ternary digit sums are both prime %d-%d: %d\n",start,stop,count)
    exit(0)
}
function sum_digits(n,base,  sum) {
    do {
      sum += n % base
    } while (n = int(n/base))
    return(sum)
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
