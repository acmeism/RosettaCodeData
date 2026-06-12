# syntax: GAWK -f FOUR_SIDES_OF_SQUARE.AWK
BEGIN {
    for (n=6; n<=7; n++) {
      for (i=1; i<=n; i++) {
        for (j=1; j<=n; j++) {
          tmp = (i==1 || i==n || j==1 || j==n) ? 1 : 0
          printf("%2d",tmp)
        }
        printf("\n")
      }
      print("")
    }
    exit(0)
}
