# syntax: GAWK -f STRANGE_PLUS_NUMBERS.AWK
BEGIN {
    start = 100
    stop = 500
    for (i=start; i<=stop; i++) {
      c1 = substr(i,1,1)
      c2 = substr(i,2,1)
      c3 = substr(i,3,1)
      if (is_prime(c1 + c2) && is_prime(c2 + c3)) {
        printf("%d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nStrange plus numbers %d-%d: %d\n",start,stop,count)
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
