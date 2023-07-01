# syntax: GAWK -f CATALAN_NUMBERS_PASCALS_TRIANGLE.AWK
# converted from C
BEGIN {
    printf("1")
    for (n=2; n<=15; n++) {
      num = den = 1
      for (k=2; k<=n; k++) {
        num *= (n + k)
        den *= k
        catalan = num / den
      }
      printf(" %d",catalan)
    }
    printf("\n")
    exit(0)
}
