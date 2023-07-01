# syntax: GAWK -f TWIN_PRIMES.AWK
BEGIN {
    n = 1
    for (i=1; i<=6; i++) {
      n *= 10
      printf("twin prime pairs < %8s : %d\n",n,count_twin_primes(n))
    }
    exit(0)
}
function count_twin_primes(limit,  count,i,p1,p2,p3) {
    p1 = 0
    p2 = p3 = 1
    for (i=5; i<=limit; i++) {
      p3 = p2
      p2 = p1
      p1 = is_prime(i)
      if (p3 && p1) {
        count++
      }
    }
    return(count)
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
