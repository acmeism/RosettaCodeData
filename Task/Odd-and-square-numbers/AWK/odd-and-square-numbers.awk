# syntax: GAWK -f ODD_AND_SQUARE_NUMBERS.AWK
BEGIN {
    start = 100
    stop = 999
    i = n = 1
    while (n <= stop) {
      if (n >= start) {
        printf("%5d%1s",n,++count%10?"":"\n")
      }
      n += 8 * i++
    }
    printf("\nOdd and square numbers %d-%d: %d\n",start,stop,count)
    exit(0)
}
