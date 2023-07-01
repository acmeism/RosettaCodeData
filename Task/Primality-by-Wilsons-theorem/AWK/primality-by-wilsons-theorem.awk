# syntax: GAWK -f PRIMALITY_BY_WILSONS_THEOREM.AWK
# converted from FreeBASIC
BEGIN {
    start = 2
    stop = 200
    for (i=start; i<=stop; i++) {
      if (is_wilson_prime(i)) {
        printf("%5d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nWilson primality test range %d-%d: %d\n",start,stop,count)
    exit(0)
}
function is_wilson_prime(n,  fct,i) {
    fct = 1
    for (i=2; i<=n-1; i++) {
      # because (a mod n)*b = (ab mod n)
      # it is not necessary to calculate the entire factorial
      fct = (fct * i) % n
    }
    return(fct == n-1)
}
