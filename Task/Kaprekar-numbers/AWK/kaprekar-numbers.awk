# syntax: GAWK -f KAPREKAR_NUMBERS.AWK
BEGIN {
    limit = 1000000
    printf("%d\n",1)
    n = 1
    for (i=2; i<limit; i++) {
      squared = sprintf("%.0f",i*i)
      for (j=1; j<=length(squared); j++) {
        L = substr(squared,1,j) + 0
        R = substr(squared,j+1) + 0
        if (R == 0) {
          continue
        }
        if (L + R == i) {
          n++
          if (i <= 10000) {
            printf("%d\n",i)
          }
          break
        }
      }
    }
    printf("%d Kaprekar numbers < %s\n",n,limit)
    exit(0)
}
