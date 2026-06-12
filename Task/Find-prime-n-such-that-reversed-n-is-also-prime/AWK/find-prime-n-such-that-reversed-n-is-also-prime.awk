# syntax: GAWK -f FIND_PRIME_N_FOR_THAT_REVERSED_N_IS_ALSO_PRIME.AWK
BEGIN {
    start = 1
    stop = 500
    for (i=start; i<=stop; i++) {
      if (is_prime(i) && is_prime(revstr(i,length(i)))) {
        printf("%3d%1s",i,++count%10?"":"\n")
      }
    }
    printf("\nReversible primes %d-%d: %d\n",start,stop,count)
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
function revstr(str,start) {
    if (start == 0) {
      return("")
    }
    return( substr(str,start,1) revstr(str,start-1) )
}
