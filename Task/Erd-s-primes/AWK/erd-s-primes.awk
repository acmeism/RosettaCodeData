# syntax: GAWK -f ERDOS-PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    while (++i) {
      if (is_erdos_prime(i)) {
        if (i < 2500) {
          printf("%d ",i)
          count1++
        }
        if (++count2 == 7875) {
          printf("\nErdos primes 1-2500: %d\nErdos prime %d: %d\n",count1,count2,i)
          break
        }
      }
    }
    exit(0)
}
function is_erdos_prime(p,  kf,m) {
    if (!is_prime(p)) { return(0) }
    kf = m = 1
    while (kf < p) {
      kf *= m++
      if (is_prime(p-kf)) { return(0) }
    }
    return(1)
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
