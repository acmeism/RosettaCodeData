# syntax: GAWK -f COUNT_IN_FACTORS.AWK
BEGIN {
    fmt = "%d=%s\n"
    for (i=1; i<=16; i++) {
      printf(fmt,i,factors(i))
    }
    i = 2144; printf(fmt,i,factors(i))
    i = 6358; printf(fmt,i,factors(i))
    exit(0)
}
function factors(n,  f,p) {
    if (n == 1) {
      return(1)
    }
    p = 2
    while (p <= n) {
      if (n % p == 0) {
        f = sprintf("%s%s*",f,p)
        n /= p
      }
      else {
        p++
      }
    }
    return(substr(f,1,length(f)-1))
}
