# syntax: GAWK -f JENSENS_DEVICE.AWK
# converted from FreeBASIC
BEGIN {
    evaluation()
    exit(0)
}
function evaluation(  hi,i,lo,tmp) {
    lo = 1
    hi = 100
    for (i=lo; i<=hi; i++) {
      tmp += (1/i)
    }
    printf("%.15f\n",tmp)
}
