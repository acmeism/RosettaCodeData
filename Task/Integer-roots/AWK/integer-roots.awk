# syntax: GAWK -f INTEGER_ROOTS.AWK
# converted from BASIC256
BEGIN {
    printf("%s\n",main(3,8))
    printf("%s\n",main(3,9))
    printf("%s\n",main(4,167))
    exit(0)
}
function main(n,x) {
    for (nr=floor(sqrt(x)); nr>1; nr--) {
      if ((nr ^ n) <= x) {
        return(sprintf("%d,%d = %d",n,x,nr))
      }
    }
}
function floor(x, y) { y=int(x) ; return (y>x)?y-1:y }
