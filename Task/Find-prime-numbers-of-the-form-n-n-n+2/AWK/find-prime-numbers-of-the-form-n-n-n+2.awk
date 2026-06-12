# syntax: GAWK -f FIND_PRIME_NUMBERS_OF_THE_FORM_NNN2.AWK
BEGIN {
    start = 1
    stop = 200
    for (n=start; n<=stop; n++) {
      p = n*n*n + 2
      if (is_prime(p)) {
        printf("%3d %'10d\n",n,p)
        count++
      }
    }
    printf("Prime numbers %d-%d of the form n*n*n+2: %d\n",start,stop,count)
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
