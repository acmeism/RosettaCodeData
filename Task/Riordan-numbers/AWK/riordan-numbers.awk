# syntax: GAWK -f RIORDAN_NUMBERS.AWK
# converted from EasyLang
BEGIN {
    limit = 32
    printf("First %d Riordan numbers:\n",limit)
    app = 1
    ap = 0
    printf("%14d%14d",app,ap)
    for (n=2; n<=limit-1; n++) {
      a = (n - 1) * (2 * ap + 3 * app) / (n + 1)
      printf("%14d%s",a,(n+1)%4?"":"\n")
      app = ap
      ap = a
    }
    printf("\n")
    exit(0)
}
