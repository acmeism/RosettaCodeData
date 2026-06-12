# syntax: GAWK -f SUM_OF_PRIMES_IN_ODD_POSITIONS_IS_PRIME.AWK
# converted from Ring
BEGIN {
    print("     i      p    sum")
    print("------ ------ ------")
    start = 2
    stop = 999
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        if (++nr % 2 == 1) {
          sum += i
          if (is_prime(sum)) {
            count++
            printf("%6d %6d %6d\n",nr,i,sum)
          }
        }
      }
    }
    printf("Odd indexed primes %d-%d: %d\n",start,stop,count)
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
