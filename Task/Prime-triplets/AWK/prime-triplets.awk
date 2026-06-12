# syntax: GAWK -f PRIME_TRIPLETS.AWK
BEGIN {
    start = 1
    stop = 5499
    for (i=start; i<=stop; i++) {
      if (is_prime(i+6) && is_prime(i+2) && is_prime(i)) {
        printf("%d %d %d\n",i,i+2,i+6)
        count++
      }
    }
    printf("Prime Triplets %d-%d: %d\n",start,stop,count)
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
