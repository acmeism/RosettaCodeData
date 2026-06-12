# syntax: GAWK -f PIPRIMES.AWK
# converted from FreeBASIC
BEGIN {
    while (1) {
      if (is_prime(++curr)) {
        running++
      }
      if (running == 22) {
        break
      }
      printf("%3d%1s",running,++count%10?"":"\n")
    }
    printf("\nPiPrimes 1-%d: %d\n",running-1,count)
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
