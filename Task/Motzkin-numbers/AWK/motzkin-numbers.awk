# syntax: GAWK --bignum -f MOTZKIN_NUMBERS.AWK
BEGIN {
    print(" n         Motzkin[n] prime")
    limit = 41
    m[0] = m[1] = 1
    for (i=2; i<=limit; i++) {
      m[i] = (m[i-1]*(2*i+1) + m[i-2]*(3*i-3)) / (i + 2)
    }
    for (i=0; i<=limit; i++) {
      printf("%2d %18d %3d\n",i,m[i],is_prime(m[i]))
    }
    exit(0)
}
function is_prime(x,  i) {
    if (x <= 1) {
      return(0)
    }
    for (i=2; i<=int(sqrt(x)); i++) {
      if (x % i == 0) {
        return(0)
      }
    }
    return(1)
}
