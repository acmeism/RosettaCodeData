# syntax: GAWK -f TEST_INTEGERNESS.AWK
BEGIN {
    n = split("25.000000,24.999999,25.000100,-2.1e120,-5e-2,NaN,Inf,-0.05",arr,",")
    for (i=1; i<=n; i++) {
      s = arr[i]
      x = (s == int(s)) ? 1 : 0
      printf("%d %s\n",x,s)
    }
    exit(0)
}
