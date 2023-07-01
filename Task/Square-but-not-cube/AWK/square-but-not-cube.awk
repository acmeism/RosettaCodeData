# syntax: GAWK -f SQUARE_BUT_NOT_CUBE.AWK
BEGIN {
    while (n < 30) {
      sqpow = ++square ^ 2
      if (is_cube(sqpow) == 0) {
        n++
        printf("%4d\n",sqpow)
      }
      else {
        printf("%4d is square and cube\n",sqpow)
      }
    }
    exit(0)
}
function is_cube(x,  i) {
    for (i=1; i<=x; i++) {
      if (i ^ 3 == x) {
        return(1)
      }
    }
    return(0)
}
