# syntax: GAWK -f IDENTITY_MATRIX.AWK size
BEGIN {
    size = ARGV[1]
    if (size !~ /^[0-9]+$/) {
      print("size invalid or missing from command line")
      exit(1)
    }
    for (i=1; i<=size; i++) {
      for (j=1; j<=size; j++) {
        x = (i == j) ? 1 : 0
        printf("%2d",x) # print
        arr[i,j] = x # build
      }
      printf("\n")
    }
    exit(0)
}
