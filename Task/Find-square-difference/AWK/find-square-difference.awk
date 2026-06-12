# syntax: GAWK -f FIND_SQUARE_DIFFERENCE.AWK
BEGIN {
    n = 1001
    while (i^2-(i-1)^2 < n) {
      i++
    }
    printf("%d\n",i)
    exit(0)
}
