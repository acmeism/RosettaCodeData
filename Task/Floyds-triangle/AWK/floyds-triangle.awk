# syntax: GAWK -f FLOYDS_TRIANGLE.AWK rows
BEGIN {
    rows = ARGV[1]
    if (rows !~ /^[0-9]+$/) {
      print("rows invalid or missing from command line")
      exit(1)
    }
    width = length(rows * (rows + 1) / 2) + 1 # width of last n
    for (i=1; i<=rows; i++) {
      cols++
      for (j=1; j<=cols; j++) {
        printf("%*d",width,++n)
      }
      printf("\n")
    }
    exit(0)
}
