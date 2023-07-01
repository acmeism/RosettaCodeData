# syntax: GAWK -f CATALAN_NUMBERS.AWK
BEGIN {
    for (i=0; i<=15; i++) {
      printf("%2d %10d\n",i,catalan(i))
    }
    exit(0)
}
function catalan(n,  ans) {
    if (n == 0) {
      ans = 1
    }
    else {
      ans = ((2*(2*n-1))/(n+1))*catalan(n-1)
    }
    return(ans)
}
