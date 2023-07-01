# syntax: GAWK -f GAMMA_FUNCTION.AWK
BEGIN {
    e = (1+1/100000)^100000
    pi = atan2(0,-1)

    print("X    Stirling")
    for (i=1; i<=20; i++) {
      d = i / 10
      printf("%4.2f %9.5f\n",d,gamma_stirling(d))
    }
    exit(0)
}
function gamma_stirling(x) {
    return sqrt(2*pi/x) * pow(x/e,x)
}
function pow(a,b) {
    return exp(b*log(a))
}
