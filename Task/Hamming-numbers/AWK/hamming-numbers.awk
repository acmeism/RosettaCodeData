# syntax: GAWK -f HAMMING_NUMBERS.AWK
BEGIN {
    for (i=1; i<=20; i++) {
      printf("%d ",hamming(i))
    }
    printf("\n1691: %d\n",hamming(1691))
    exit(0)
}
function hamming(limit,  h,i,j,k,n,x2,x3,x5) {
    h[0] = 1
    x2 = 2
    x3 = 3
    x5 = 5
    for (n=1; n<=limit; n++) {
      h[n] = min(x2,min(x3,x5))
      if (h[n] == x2) { x2 = 2 * h[++i] }
      if (h[n] == x3) { x3 = 3 * h[++j] }
      if (h[n] == x5) { x5 = 5 * h[++k] }
    }
    return(h[limit-1])
}
function min(x,y) {
    return((x < y) ? x : y)
}
