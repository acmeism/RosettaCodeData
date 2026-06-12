# syntax: GAWK -f SIGN_OF_AN_INTEGER_SIGNUM.AWK
BEGIN {
    n = split("-10,42,0,-0,1.2",arr,",")
    for (i=1; i<=n; i++) {
      x = arr[i]
      printf("%5s  %s\n",x,signum(x))
    }
    exit(0)
}
function signum(n) {
    return((n>0) ? 1 : (n<0) ? -1 : n)
}
