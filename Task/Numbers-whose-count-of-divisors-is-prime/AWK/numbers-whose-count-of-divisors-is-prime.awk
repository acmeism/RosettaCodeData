# syntax: GAWK -f NUMBERS_WHOSE_COUNT_OF_DIVISORS_IS_PRIME.AWK
BEGIN {
    start = 2
    stop = 99999
    stop2 = 999
    for (i=start; i*i<=stop; i++) {
      n = count_divisors(i*i)
      if (n>2 && is_prime(n)) {
        printf("%6d%1s",i*i,++count%10?"":"\n")
        if (i*i <= stop2) {
          count2++
        }
      }
    }
    printf("\nNumbers with odd prime divisor counts %d-%d: %d\n",start,stop2,count2)
    printf("Numbers with odd prime divisor counts %d-%d: %d\n",start,stop,count)
    exit(0)
}
function count_divisors(n,  count,i) {
    for (i=1; i*i<=n; i++) {
      if (n % i == 0) {
        count += (i == n / i) ? 1 : 2
      }
    }
    return(count)
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
