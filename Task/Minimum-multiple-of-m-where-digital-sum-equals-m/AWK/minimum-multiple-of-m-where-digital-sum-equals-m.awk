# syntax: GAWK -f MINIMUM_MULTIPLE_OF_M_WHERE_DIGITAL_SUM_EQUALS_M.AWK
BEGIN {
    start = 1
    stop = 70
    printf("A131382 %d-%d:\n",start,stop)
    for (n=start; n<=stop; n++) {
      for (m=1; ; m++) {
        if (digit_sum(m*n,10) == n) {
          printf("%9d%1s",m,++count%10?"":"\n")
          break
        }
      }
    }
    exit(0)
}
function digit_sum(n,b,  s) { # digital sum of n in base b
    while (n) {
      s += n % b
      n = int(n/b)
    }
    return(s)
}
