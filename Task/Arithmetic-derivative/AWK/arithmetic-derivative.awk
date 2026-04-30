# syntax: GAWK -f ARITHMETIC_DERIVATIVE.AWK
# converted from Action!
BEGIN {
    for (n=-99; n<=100; n++) {
      l = 0
      f = 3
      z = (n < 0) ? -n : n
      while (z >= 2) {
        while (z % 2 == 0) {
          l += n / 2
          z /= 2
        }
        if (f <= z) {
          while (z % f == 0) {
            l += n / f
            z /= f
          }
          f += 2
        }
      }
      printf("%6d",l)
      if ((n+100) % 10 == 0) { printf("\n") }
    }
    exit(0)
}
