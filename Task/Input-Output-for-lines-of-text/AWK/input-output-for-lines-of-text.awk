# syntax: GAWK -f INPUT_OUTPUT_FOR_LINES_OF_TEXT.AWK
BEGIN {
    getline n
    while (i++ < n) {
      getline
      str = sprintf("%s%s\n",str,$0)
    }
    printf("%s",str)
    exit(0)
}
