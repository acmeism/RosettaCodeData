# syntax: GAWK -f NUMBERS_IN_BASE-16_REPRESENTATION_THAT_CANNOT_BE_WRITTEN_WITH_DECIMAL_DIGITS.AWK
BEGIN {
    start = 1
    stop = 499
    for (i=start; i<=stop; i++) {
      if (sprintf("%X",i) !~ /[0-9]/) {
        printf("%4d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nHexadecimal numbers without 0-9, %d-%d: %d\n",start,stop,count)
    exit(0)
}
