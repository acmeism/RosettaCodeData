# syntax: GAWK -f EUCLID-MULLIN_SEQUENCE.AWK
# converted from FreeBASIC
BEGIN {
    limit = 7 # we'll stop here
    arr[0] = 2
    printf("%s ",arr[0])
    for (i=1; i<=limit; i++) {
      k = 3
      while (1) {
        em = 1
        for (j=0; j<=i-1; j++) {
          em = (em * arr[j]) % k
        }
        em = (em + 1) % k
        if (em == 0) {
          arr[i] = k
          printf("%s ",arr[i])
          break
        }
        k += 2
      }
    }
    printf("\n")
    exit(0)
}
