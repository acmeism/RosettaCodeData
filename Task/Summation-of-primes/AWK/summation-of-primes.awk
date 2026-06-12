# syntax: GAWK -f SUMMATION_OF_PRIMES.AWK
BEGIN {
    main(10)
    main(2000000)
    exit(0)
}
function main(stop,  count,sum) {
    if (stop < 3) {
      return
    }
    count = 1
    sum = 2
    for (i=3; i<stop; i+=2) {
      if (is_prime(i)) {
        sum += i
        count++
      }
    }
    printf("The %d primes below %d sum to %d\n",count,stop,sum)
}
function is_prime(n,  d) {
    d = 5
    if (n < 2) { return(0) }
    if (n % 2 == 0) { return(n == 2) }
    if (n % 3 == 0) { return(n == 3) }
    while (d*d <= n) {
      if (n % d == 0) { return(0) }
      d += 2
      if (n % d == 0) { return(0) }
      d += 4
    }
    return(1)
}
