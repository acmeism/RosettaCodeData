# syntax: GAWK -f CASTING_OUT_NINES.AWK
# converted from C
BEGIN {
    base = 10
    for (k=1; k<=base^2; k++) {
      c1++
      if (k % (base-1) == (k*k) % (base-1)) {
        c2++
        printf("%d ",k)
      }
    }
    printf("\nTrying %d numbers instead of %d numbers saves %.2f%%\n",c2,c1,100-(100*c2/c1))
    exit(0)
}
