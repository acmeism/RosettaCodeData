# syntax: GAWK -M -f HICKERSON_SERIES_OF_ALMOST_INTEGERS.AWK
# using GNU Awk 4.1.0, API: 1.0 (GNU MPFR 3.1.2, GNU MP 5.1.2)
BEGIN {
    PREC = 100
    for (i=1; i<=17; i++) {
      h = sprintf("%25.5f",factorial(i) / (2 * log(2) ^ (i + 1)))
      msg = (h ~ /\.[09]/) ? "true" : "false"
      printf("%2d %s almost integer: %s\n",i,h,msg)
    }
    exit(0)
}
function factorial(n,  i,out) {
    out = 1
    for (i=2; i<=n; i++) {
      out *= i
    }
    return(out)
}
