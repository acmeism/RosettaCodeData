# syntax: GAWK -f MINIMUM_PRIMES.AWK
BEGIN {
    n1 = split("5,45,23,21,67",numbers1,",")
    n2 = split("43,22,78,46,38",numbers2,",")
    n3 = split("9,98,12,54,53",numbers3,",")
    if (n1 != n2 || n1 != n3) {
      print("error: arrays must be same length")
      exit(1)
    }
    for (i=1; i<=n1; i++) {
      m = max(max(numbers1[i],numbers2[i]),numbers3[i])
      if (m % 2 == 0) { m++ }
      while (!is_prime(m)) { m += 2 }
      primes[i] = m
      printf("%d ",primes[i])
    }
    printf("\n")
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
function max(x,y) { return((x > y) ? x : y) }
