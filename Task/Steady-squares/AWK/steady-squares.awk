# syntax: GAWK -f STEADY_SQUARES.AWK
BEGIN {
    start = 1
    stop = 999999
    for (i=start; i<=stop; i++) {
      n = i ^ 2
      if (n ~ (i "$")) {
        printf("%6d^2 = %12d\n",i,n)
        count++
      }
    }
    printf("\nSteady squares %d-%d: %d\n",start,stop,count)
    exit(0)
}
