# syntax: GAWK -f PALINDROMIC_PRIMES_IN_BASE_16.AWK
BEGIN {
    start = 1
    stop = 499
    for (i=start; i<=stop; i++) {
      hex = sprintf("%X",i)
      if (is_prime(i) && hex == reverse(hex)) {
        printf("%4s%1s",hex,++count%10?"":"\n")
      }
    }
    printf("\nPalindromic primes %d-%d: %d\n",start,stop,count)
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
function reverse(str,  i,rts) {
    for (i=length(str); i>=1; i--) {
      rts = rts substr(str,i,1)
    }
    return(rts)
}
