# syntax: GAWK -f ROOTS_OF_UNITY.AWK
BEGIN {
    pi = 3.1415926
    for (n=2; n<=5; n++) {
      printf("%d: ",n)
      for (root=0; root<=n-1; root++) {
        real = cos(2 * pi * root / n)
        imag = sin(2 * pi * root / n)
        printf("%8.5f %8.5fi",real,imag)
        if (root != n-1) { printf(", ") }
      }
      printf("\n")
    }
    exit(0)
}
