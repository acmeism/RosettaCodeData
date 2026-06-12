# syntax: GAWK -f NEIGHBOUR_PRIMES.AWK
BEGIN {
    print("   p    q  p*q+2")
    print("---- ---- ------")
    start = 1
    stop = 499
    for (p=start; p<=stop; p++) {
      if (!is_prime(p)) { continue }
      q = p + 1
      while (!is_prime(q)) {
        q++
      }
      if (!is_prime(p*q+2)) { continue }
      printf("%4d %4d %6d\n",p,q,p*q+2)
      count++
    }
    printf("Neighbour primes %d-%d: %d\n",start,stop,count)
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
