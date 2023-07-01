# syntax: GAWK -f ZIG-ZAG_MATRIX.AWK [-v offset={0|1}] [size]
BEGIN {
# offset: "0" prints 0 to size^2-1 while "1" prints 1 to size^2
    offset = (offset == "") ? 0 : offset
    size = (ARGV[1] == "") ? 5 : ARGV[1]
    if (offset !~ /^[01]$/) { exit(1) }
    if (size !~ /^[0-9]+$/) { exit(1) }
    width = length(size ^ 2 - 1 + offset) + 1
    i = j = 1
    for (n=0; n<=size^2-1; n++) { # build array
      arr[i-1,j-1] = n + offset
      if ((i+j) % 2 == 0) {
        if (j < size) { j++ } else { i+=2 }
        if (i > 1) { i-- }
      }
      else {
        if (i < size) { i++ } else { j+=2 }
        if (j > 1) { j-- }
      }
    }
    for (row=0; row<size; row++) { # show array
      for (col=0; col<size; col++) {
        printf("%*d",width,arr[row,col])
      }
      printf("\n")
    }
    exit(0)
}
