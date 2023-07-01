# syntax: GAWK -f MUNCHAUSEN_NUMBERS.AWK
BEGIN {
    for (i=1; i<=5000; i++) {
      sum = 0
      for (j=1; j<=length(i); j++) {
        digit = substr(i,j,1)
        sum += digit ^ digit
      }
      if (i == sum) {
        printf("%d\n",i)
      }
    }
    exit(0)
}
