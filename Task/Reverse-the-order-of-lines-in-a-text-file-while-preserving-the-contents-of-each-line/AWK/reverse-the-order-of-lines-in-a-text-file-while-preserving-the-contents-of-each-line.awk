# syntax: GAWK -f REVERSE_THE_ORDER_OF_LINES_IN_A_TEXT_FILE_WHILE_PRESERVING_THE_CONTENTS_OF_EACH_LINE.AWK filename
{ arr[NR] = $0 }
END {
    for (i=NR; i>=1; i--) {
      printf("%s\n",arr[i])
    }
    exit(0)
}
