# syntax: GAWK -f BRILLIANT_NUMBERS.AWK
# converted from FreeBASIC
BEGIN {
    n = 0
    while (count < 100) {
      ff = first_prime_factor(n)
      sf = n / ff
      if (is_prime(sf) && length(ff) == length(sf)) {
        printf("%5d",n)
        if (++count % 10 == 0) { printf("\n") }
      }
      n++
    }
    printf("\n")
    count = expo = n = 0
    while (expo < 7) {
      ff = first_prime_factor(n)
      sf = n / ff
      if (is_prime(sf) && length(ff) == length(sf)) {
        count++
        if (n > 10^expo) {
          printf("%8d is brilliant # %d\n",n,count)
          expo++
        }
      }
      n++
    }
    exit(0)
}
function first_prime_factor(n,  i) {
    if (n % 2 == 0) {
      return(2)
    }
    for (i=3; i<=sqrt(n); i+=2) {
      if (n % i == 0) {
        return(i)
      }
    }
    return(n)
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
