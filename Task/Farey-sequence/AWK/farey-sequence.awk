# syntax: GAWK -f FAREY_SEQUENCE.AWK
BEGIN {
    for (i=1; i<=11; i++) {
      farey(i); printf("\n")
    }
    for (i=100; i<=1000; i+=100) {
      printf(" %d items\n",farey(i))
    }
    exit(0)
}
function farey(n,  a,aa,b,bb,c,cc,d,dd,items,k) {
    a = 0; b = 1; c = 1; d = n
    printf("%d:",n)
    if (n <= 11) {
      printf(" %d/%d",a,b)
    }
    while (c <= n) {
      k = int((n+b)/d)
      aa = c; bb = d; cc = k*c-a; dd = k*d-b
      a = aa; b = bb; c = cc; d = dd
      items++
      if (n <= 11) {
        printf(" %d/%d",a,b)
      }
    }
    return(1+items)
}
