# syntax: GAWK -f DIGITAL_ROOT.AWK
BEGIN {
    n = split("627615,39390,588225,393900588225,10,199",arr,",")
    for (i=1; i<=n; i++) {
      dr = digitalroot(arr[i],10)
      printf("%12.0f has additive persistence %d and digital root of %d\n",arr[i],p,dr)
    }
    exit(0)
}
function digitalroot(n,b) {
    p = 0 # global
    while (n >= b) {
      p++
      n = digitsum(n,b)
    }
    return(n)
}
function digitsum(n,b,  q,s) {
    while (n != 0) {
      q = int(n / b)
      s += n - q * b
      n = q
    }
    return(s)
}
