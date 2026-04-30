# syntax: GAWK --bignum -f ISQRT_INTEGER_SQUARE_ROOT_OF_X.AWK
# converted from LUA
BEGIN {
    print("Integer square root for numbers 0-65:")
    for (n=0; n<=65; n++) {
      printf("%2d%s",isqrt(n),++count%10?"":"\n")
    }
    printf("\n\n")
    print("Integer square roots of odd powers of 7:")
    print(" n |                7^n |  isqrt(7^n)")
    print("---|--------------------|------------")
    p = 7
    n = 1
    while (n <= 21) {
      printf("%2d | %18d | %11d\n",n,p,isqrt(p))
      n += 2
      p *= 49
    }
    exit(0)
}
function isqrt(x,  q,r,t) {
    q = 1
    r = 0
    while (q <= x) {
      q = lshift(q,2)
    }
    while (q > 1) {
      q = rshift(q,2)
      t = x - r - q
      r = rshift(r,1)
      if (t >= 0) {
        x = t
        r += q
      }
    }
    return(r)
}
