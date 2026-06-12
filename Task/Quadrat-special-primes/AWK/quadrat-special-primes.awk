# syntax: GAWK -f QUADRAT_SPECIAL_PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    stop = 15999
    p = 2
    j = 1
    printf("%5d ",p)
    count++
    while (1) {
      while (1) {
        if (is_prime(p+j*j)) { break }
        j++
      }
      p += j*j
      if (p > stop) { break }
      printf("%5d%1s",p,++count%10?"":"\n")
      j = 1
    }
    printf("\nQuadrat special primes 1-%d: %d\n",stop,count)
    exit(0)
}
function is_prime(x,  i) {
    if (x <= 1) {
      return(0)
    }
    for (i=2; i<=int(sqrt(x)); i++) {
      if (x % i == 0) {
        return(0)
      }
    }
    return(1)
}
