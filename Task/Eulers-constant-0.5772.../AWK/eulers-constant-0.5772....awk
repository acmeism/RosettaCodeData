# syntax: GAWK -f EULERS_CONSTANT.AWK
# converted from LUA
BEGIN {
    Hn = 1
    n = 10^8
    for (i=2; i<=n; i++) {
      Hn += (1/i)
    }
    gamma = Hn - log(n)
    printf("%.8f\n",gamma)
    exit(0)
}
