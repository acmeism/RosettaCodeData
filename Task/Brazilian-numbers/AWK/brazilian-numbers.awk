# syntax: GAWK -f BRAZILIAN_NUMBERS.AWK
# converted from C
BEGIN {
    split(",odd ,prime ",kinds,",")
    for (i=1; i<=3; ++i) {
      printf("first 20 %sBrazilian numbers:",kinds[i])
      c = 0
      n = 7
      while (1) {
        if (is_brazilian(n)) {
          printf(" %d",n)
          if (++c == 20) {
            printf("\n")
            break
          }
        }
        switch (i) {
          case 1:
            n++
            break
          case 2:
            n += 2
            break
          case 3:
            do {
              n += 2
            } while (!is_prime(n))
            break
        }
      }
    }
    exit(0)
}
function is_brazilian(n,  b) {
    if (n < 7) { return(0) }
    if (!(n % 2) && n >= 8) { return(1) }
    for (b=2; b<n-1; ++b) {
      if (same_digits(n,b)) { return(1) }
    }
    return(0)
}
function is_prime(n,  d) {
    d = 5
    if (n < 2) { return(0) }
    if (!(n % 2)) { return(n == 2) }
    if (!(n % 3)) { return(n == 3) }
    while (d*d <= n) {
      if (!(n % d)) { return(0) }
      d += 2
      if (!(n % d)) { return(0) }
      d += 4
    }
    return(1)
}
function same_digits(n,b,  f) {
    f = n % b
    n = int(n/b)
    while (n > 0) {
      if (n % b != f) { return(0) }
      n = int(n/b)
    }
    return(1)
}
