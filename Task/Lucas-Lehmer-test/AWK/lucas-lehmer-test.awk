# syntax: GAWK -f LUCAS-LEHMER_TEST.AWK
# converted from Pascal
BEGIN {
    printf("Mersenne primes:")
    n = 1
    for (exponent=2; exponent<=32; exponent++) {
      s = (exponent == 2) ? 0 : 4
      n = (n+1)*2-1
      for (i=1; i<=exponent-2; i++) {
        s = (s*s-2)%n
      }
      if (s == 0) {
        printf(" M%s",exponent)
      }
    }
    printf("\n")
    exit(0)
}
