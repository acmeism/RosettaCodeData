# syntax: GAWK -f CALMO_NUMBERS.AWK
# converted from Scala
BEGIN {
    for (n=1; n<1000; n++) {
      if (is_calmo(n)) {
         printf("%d ",n)
      }
    }
    printf("\n")
    exit(0)
}
function is_calmo(n) {
    limite = sqrt(n)
    cont = sumD = sumQ = 0
    k = 0
    q = 0
    d = 2
    while (d < limite) {
      q = n / d
      if (n % d == 0) {
        cont += 1
        sumD += d
        sumQ += q
        if (cont == 3) {
          k += 3
          if (!is_prime(sumD)) { return(0) }
          if (!is_prime(sumQ)) { return(0) }
          cont = sumD = sumQ = 0
        }
      }
      d++
    }
    if (cont != 0 || k == 0) { return(0) }
    return(1)
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
