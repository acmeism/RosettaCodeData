# syntax: GAWK -f MODULAR_INVERSE.AWK
# converted from C
BEGIN {
    printf("%s\n",mod_inv(42,2017))
    exit(0)
}
function mod_inv(a,b,  b0,t,q,x0,x1) {
    b0 = b
    x0 = 0
    x1 = 1
    if (b == 1) {
      return(1)
    }
    while (a > 1) {
      q = int(a / b)
      t = b
      b = int(a % b)
      a = t
      t = x0
      x0 = x1 - q * x0
      x1 = t
    }
    if (x1 < 0) {
      x1 += b0
    }
    return(x1)
}
