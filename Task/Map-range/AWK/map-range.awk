# syntax: GAWK -f MAP_RANGE.AWK
BEGIN {
    a1 = 0
    a2 = 10
    b1 = -1
    b2 = 0
    for (i=a1; i<=a2; i++) {
      printf("%g maps to %g\n",i,map_range(a1,a2,b1,b2,i))
    }
    exit(0)
}
function map_range(a1,a2,b1,b2,num) {
    return b1 + ((num-a1) * (b2-b1) / (a2-a1))
}
