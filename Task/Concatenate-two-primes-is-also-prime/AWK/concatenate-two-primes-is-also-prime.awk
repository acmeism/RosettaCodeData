# syntax: GAWK -f CONCATENATE_TWO_PRIMES_IS_ALSO_PRIME.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    start = 1
    stop = 99
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        for (j=start; j<=stop; j++) {
          if (is_prime(j)) {
            if (is_prime(i j)) {
              arr[i j] = ""
            }
          }
        }
      }
    }
    PROCINFO["sorted_in"] = "@ind_num_asc" ; SORTTYPE = 1
    for (i in arr) {
      printf("%5d%1s",i,++count%10?"":"\n")
    }
    printf("\nConcatenate two primes is also prime %d-%d: %d\n",start,stop,count)
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
