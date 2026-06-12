# syntax: GAWK -f SMALLEST_POWER_OF_6_WHOSE_DECIMAL_EXPANSION_CONTAINS_N.AWK
BEGIN {
    printf(" n power %30s\n","smallest power of 6")
    for (n=0; n<22; n++) {
      p = 1
      power = 0
      while (p !~ n) {
        p *= 6
        power++
      }
      printf("%2d %5d %'30d\n",n,power,p)
    }
    exit(0)
}
