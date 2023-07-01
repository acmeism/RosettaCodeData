# syntax: GAWK -f MCNUGGETS_PROBLEM.AWK
# converted from Go
BEGIN {
    limit = 100
    for (a=0; a<=limit; a+=6) {
      for (b=a; b<=limit; b+=9) {
        for (c=b; c<=limit; c+=20) {
          arr[c] = 1
        }
      }
    }
    for (i=limit; i>=0; i--) {
      if (!arr[i]+0) {
        printf("%d\n",i)
        break
      }
    }
    exit(0)
}
