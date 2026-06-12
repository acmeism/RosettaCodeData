# syntax: GAWK -f PRIMES_WHICH_CONTAIN_ONLY_ONE_ODD_NUMBER.AWK
BEGIN {
    start = 1
    stop = 999
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        if (gsub(/[13579]/,"&",i) == 1) {
          rec_odd = sprintf("%s%5d%1s",rec_odd,i,++count_odd%10?"":"\n")
        }
        if (gsub(/[02468]/,"&",i) == 1) {
          rec_even = sprintf("%s%5d%1s",rec_even,i,++count_even%10?"":"\n")
        }
      }
    }
    printf("%s\nPrimes which contain only one odd number %d-%d: %d\n\n",rec_odd,start,stop,count_odd)
    printf("%s\nPrimes which contain only one even number %d-%d: %d\n\n",rec_even,start,stop,count_even)
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
