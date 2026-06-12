# syntax: GAWK -f ODD_SQUAREFREE_SEMIPRIMES.AWK
# converted from C++
BEGIN {
    start = 1
    stop = 999
    for (i=start; i<=stop; i+=2) {
      if (is_odd_square_free_semiprime(i)) {
        printf("%4d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nOdd Square Free Semiprimes %d-%d: %d\n",start,stop,count)
    exit(0)
}
function is_odd_square_free_semiprime(n,  count,i) {
    if (and(n,1) == 0) {
      return(0)
    }
    for (i=3; i*i<=n; i+=2) {
      for (; n%i==0; n=int(n/i)) {
        if (++count > 1)  {
          return(0)
        }
      }
    }
    return(count==1)
}
