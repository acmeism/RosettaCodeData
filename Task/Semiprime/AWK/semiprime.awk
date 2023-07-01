# syntax: GAWK -f SEMIPRIME.AWK
BEGIN {
    main(0,100)
    main(1675,1680)
    exit(0)
}
function main(lo,hi,  i) {
    printf("%d-%d:",lo,hi)
    for (i=lo; i<=hi; i++) {
      if (is_semiprime(i)) {
        printf(" %d",i)
      }
    }
    printf("\n")
}
function is_semiprime(n,  i,nf) {
    nf = 0
    for (i=2; i<=n; i++) {
      while (n % i == 0) {
        if (nf == 2) {
          return(0)
        }
        nf++
        n /= i
      }
    }
    return(nf == 2)
}
