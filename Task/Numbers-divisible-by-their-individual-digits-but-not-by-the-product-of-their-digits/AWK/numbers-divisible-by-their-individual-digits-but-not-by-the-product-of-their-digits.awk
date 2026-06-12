# syntax: GAWK -f NUMBERS_DIVISIBLE_BY_THEIR_INDIVIDUAL_DIGITS_BUT_NOT_BY_THE_PRODUCT_OF_THEIR_DIGITS.AWK
# converted from C
BEGIN {
    start = 1
    stop = 999
    for (i=start; i<=stop; i++) {
      if (divisible(i)) {
        printf("%4d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nNumbers divisible by their individual digits but not by the product of their digits %d-%d: %d\n",start,stop,count)
    exit(0)
}
function divisible(n,  c,d,p) {
    p = 1
    for (c=n; c; c=int(c/10)) {
      d = c % 10
      if (!d || n % d) { return(0) }
      p *= d
    }
    return(n % p)
}
