# syntax: GAWK -f FEIGENBAUM_CONSTANT_CALCULATION.AWK
BEGIN {
    a1 = 1
    a2 = 0
    d1 = 3.2
    max_i = 13
    max_j = 10
    print(" i d")
    for (i=2; i<=max_i; i++) {
      a = a1 + (a1 - a2) / d1
      for (j=1; j<=max_j; j++) {
        x = y = 0
        for (k=1; k<=2^i; k++) {
          y = 1 - 2 * y * x
          x = a - x * x
        }
        a -= x / y
      }
      d = (a1 - a2) / (a - a1)
      printf("%2d %.8f\n",i,d)
      d1 = d
      a2 = a1
      a1 = a
    }
    exit(0)
}
