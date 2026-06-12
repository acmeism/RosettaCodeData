# syntax: GAWK -f MOSAIC_MATRIX.AWK
BEGIN {
    for (n=6; n<=7; n++) {
      for (i=1; i<=n; i++) {
        for (j=1; j<=n; j++) {
          tmp = ((i+j) % 2 == 0) ? 1 : 0
          printf("%2d",tmp)
        }
        printf("\n")
      }
      print("")
    }
    exit(0)
}
