# syntax: GAWK -f FACTORIONS.AWK
# converted from C
BEGIN {
    fact[0] = 1 # cache factorials from 0 to 11
    for (n=1; n<12; ++n) {
      fact[n] = fact[n-1] * n
    }
    for (b=9; b<=12; ++b) {
      printf("base %d factorions:",b)
      for (i=1; i<1500000; ++i) {
        sum = 0
        j = i
        while (j > 0) {
          d = j % b
          sum += fact[d]
          j = int(j/b)
        }
        if (sum == i) {
          printf(" %d",i)
        }
      }
      printf("\n")
    }
    exit(0)
}
