# syntax: GAWK -f HARMONIC_SERIES.AWK
# converted from FreeBASIC
BEGIN {
    limit = 20
    printf("The first %d harmonic numbers:\n",limit)
    for (n=1; n<=limit; n++) {
      h += 1/n
      printf("%2d %11.8f\n",n,h)
    }
    print("")
    h = 1
    n = 2
    for (i=2; i<=10; i++) {
      while (h < i) {
        h += 1/n
        n++
      }
      printf("The first harmonic number > %2d is %11.8f at position %d\n",i,h,n-1)
    }
    exit(0)
}
