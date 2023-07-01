# syntax: GAWK --bignum -f SYLVESTERS_SEQUENCE.AWK
BEGIN {
    start = 1
    stop = 10
    for (i=start; i<=stop; i++) {
      sylvester = (i == 1) ? 2 : sylvester*sylvester-sylvester+1
      printf("%2d: %d\n",i,sylvester)
      sum += 1 / sylvester
    }
    printf("\nSylvester sequence %d-%d: sum of reciprocals %30.28f\n",start,stop,sum)
    exit(0)
}
