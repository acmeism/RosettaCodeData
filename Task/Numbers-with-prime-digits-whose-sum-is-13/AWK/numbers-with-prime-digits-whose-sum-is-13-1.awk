# syntax: GAWK -f NUMBERS_WITH_PRIME_DIGITS_WHOSE_SUM_IS_13.AWK
BEGIN {
    for (i=1; i<=1000000; i++) {
      if (prime_digits_sum13(i)) {
        printf("%6d ",i)
        if (++count % 10 == 0) {
          printf("\n")
        }
      }
    }
    printf("\n")
    exit(0)
}
function prime_digits_sum13(n,  r,sum) {
     while (n > 0) {
      r = int(n % 10)
      switch (r) {
        case 2:
        case 3:
        case 5:
        case 7:
          break
        default:
          return(0)
      }
      n = int(n / 10)
      sum += r
    }
    return(sum == 13)
}
