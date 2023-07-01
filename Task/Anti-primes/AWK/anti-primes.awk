# syntax: GAWK -f ANTI-PRIMES.AWK
BEGIN {
    print("The first 20 anti-primes are:")
    while (count < 20) {
      d = count_divisors(++n)
      if (d > max_divisors) {
        printf("%d ",n)
        max_divisors = d
        count++
      }
    }
    printf("\n")
    exit(0)
}
function count_divisors(n,  count,i) {
    if (n < 2) {
      return(1)
    }
    count = 2
    for (i=2; i<=n/2; i++) {
      if (n % i == 0) {
        count++
      }
    }
    return(count)
}
