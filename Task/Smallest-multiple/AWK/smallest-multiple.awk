# syntax: GAWK --bignum -f SMALLEST_MULTIPLE.AWK
# converted from EasyLang
BEGIN {
    leng = split("10,20,200",arr,",")
    for (i=1; i<=leng; i++) {
      n = arr[i]
      res = 1
      for (p=2; p<=n; p++) {
        if (is_prime(p)) {
          f = p
          while (f * p <= n) {
            f = f * p
          }
          res *= f
        }
      }
      printf("%3d: %d\n",n,res)
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
