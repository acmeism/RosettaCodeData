# syntax: GAWK -f STRANGE_NUMBERS.AWK
BEGIN {
    start = 100
    stop = 500
    for (i=start; i<=stop; i++) {
      flag = 1
      for (j=1; j<length(i); j++) {
        if (!(is_prime(abs(substr(i,j,1)-substr(i,j+1,1))))) {
          flag = 0
          break
        }
      }
      if (flag == 1) {
        printf("%d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nStrange numbers %d-%d: %d\n",start,stop,count)
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
function abs(x) { if (x >= 0) { return x } else { return -x } }
