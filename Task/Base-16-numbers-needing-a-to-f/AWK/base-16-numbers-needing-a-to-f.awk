# syntax: GAWK -f BASE-16_REPRESENTATION.AWK
BEGIN {
    start = 1
    stop = 500
    for (i=start; i<=stop; i++) {
      if (sprintf("%X",i) ~ /[A-F]/) {
        printf("%4d%1s",i,++count%20?"":"\n")
      }
    }
    printf("\nIntegers when displayed in hex require an A-F, %d-%d: %d\n",start,stop,count)
    exit(0)
}
