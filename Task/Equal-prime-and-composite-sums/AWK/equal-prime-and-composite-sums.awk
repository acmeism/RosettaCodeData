# syntax: GAWK -f EQUAL_PRIME_AND_COMPOSITE_SUMS.AWK
# converted from LUA
BEGIN {
    limit = 8
    m = 1
    n = 2
    numC = 4
    numP = 3
    sumC = 4
    sumP = 5
    fmt = "%2s %12s %7s %11s\n"
    printf(fmt,"n","sum","primes","composites")
    gsub(/s/,"d",fmt)
    do {
      if (sumC > sumP) {
        for (;;) {
          numP += 2
          if (is_prime(numP)) { break }
        }
        sumP += numP
        n++
      }
      if (sumP > sumC) {
        for (;;) {
          numC += 1
          if (!is_prime(numC)) { break }
        }
        sumC += numC
        m++
      }
      if (sumP == sumC) {
        printf(fmt,++count,sumP,n,m)
        if (count <= limit) {
          for (;;) {
            numC += 1
            if (!is_prime(numC)) { break }
          }
          sumC += numC
          m++
        }
      }
    } while (count < limit)
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
