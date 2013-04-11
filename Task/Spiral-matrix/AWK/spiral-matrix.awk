# syntax: GAWK -f SPIRAL_MATRIX.AWK [-v offset={0|1}] [size]
# converted from BBC BASIC
BEGIN {
# offset: "0" prints 0 to size^2-1 while "1" prints 1 to size^2
    offset = (offset == "") ? 0 : offset
    size = (ARGV[1] == "") ? 5 : ARGV[1]
    if (offset !~ /^[01]$/) { exit(1) }
    if (size !~ /^[0-9]+$/) { exit(1) }
    bot_col = bot_row = 0
    top_col = top_row = size - 1
    direction = col = row = 0
    for (i=0; i<=size*size-1; i++) { # build
      arr[col,row] = i + offset
      if (direction == 0) {
        if (col < top_col) { col++ }
        else { direction = 1 ; row++ ; bot_row++ }
      }
      else if (direction == 1) {
        if (row < top_row) { row++ }
        else { direction = 2 ; col-- ; top_col-- }
      }
      else if (direction == 2) {
        if (col > bot_col) { col-- }
        else { direction = 3 ; row-- ; top_row-- }
      }
      else if (direction == 3) {
        if (row > bot_row) { row-- }
        else { direction = 0 ; col++ ; bot_col++ }
      }
    }
    width = length(size ^ 2 - 1 + offset) + 1 # column width
    for (i=0; i<size; i++) { # print
      for (j=0; j<size; j++) {
        printf("%*d",width,arr[j,i])
      }
      printf("\n")
    }
    exit(0)
}
