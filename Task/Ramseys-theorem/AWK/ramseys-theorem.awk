# syntax: GAWK -f RAMSEYS_THEOREM.AWK
# converted from Ring
BEGIN {
    for (i=1; i<=17; i++) {
      arr[i,i] = -1
    }
    k = 1
    while (k <= 8) {
      for (i=1; i<=17; i++) {
        j = (i + k) % 17
        if (j != 0) {
          arr[i,j] = 1
          arr[j,i] = 1
        }
      }
      k = k * 2
    }
    for (i=1; i<=17; i++) {
      for (j=1; j<=17; j++) {
        printf("%s",arr[i,j]+0)
      }
      printf("\n")
    }
    exit(0)
}
