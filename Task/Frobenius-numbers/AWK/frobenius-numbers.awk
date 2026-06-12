# syntax: GAWK -f FROBENIUS_NUMBERS.AWK
# converted from FreeBASIC
BEGIN {
    start = 3
    stop = 9999
    pn = 2
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        f = pn * i - pn - i
        if (f > stop) { break }
        printf("%4d%1s",f,++count%10?"":"\n")
        pn = i
      }
    }
    printf("\nFrobenius numbers %d-%d: %d\n",start,stop,count)
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
