# syntax: GAWK -f SMALLEST_SQUARE_THAT_BEGINS_WITH_N.AWK
# converted from C
BEGIN {
    print("Prefix  n^2    n")
    for (i=1; i<50; i++) {
      x(i)
    }
    exit(0)
}
function x(n,  i,sq) {
    i = 1
    while (1) {
      sq = i * i
      while (sq > n) {
        sq = int(sq/10)
      }
      if (sq == n) {
        printf("%3d %7d %4d\n",n,i*i,i)
        return
      }
      i++
    }
}
