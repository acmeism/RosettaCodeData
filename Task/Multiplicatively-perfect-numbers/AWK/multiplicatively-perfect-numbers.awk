# syntax: GAWK -f MULTIPLICATIVELY_PERFECT_NUMBERS.AWK
# converted from LUA
BEGIN {
    start = 1
    stop = 499
    for (i=start; i<stop; i++) {
      if (is_mpn(i)) {
        printf("%4d%s",i,++count%10?"":"\n")
      }
    }
    printf("\nMultiplicatively perfect numbers %d-%d: %d\n",start,stop,count)
    exit(0)
}
function is_mpn(n,  d,delta,first,q,second) {
    first = second = 0
    delta = 1 + (n % 2)
    d = delta + 1
    while (d * d <= n) {
      if (n % d == 0) {
        if (second != 0) {
          return(0)
        }
        first = d
        q = floor(n/d)
        if (q != d) {
          second = q
        }
      }
      d += delta
    }
    return(first * second == n)
}
function floor(x, y) { y=int(x) ; return (y>x)?y-1:y }
