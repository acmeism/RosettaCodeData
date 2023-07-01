# syntax: GAWK -f ASCENDING_PRIMES.AWK
BEGIN {
    start = 1
    stop = 23456789
    for (i=start; i<=stop; i++) {
      if (is_prime(i)) {
        primes++
        leng = length(i)
        flag = 1
        for (j=1; j<leng; j++) {
          if (substr(i,j,1) >= substr(i,j+1,1)) {
            flag = 0
            break
          }
        }
        if (flag) {
          printf("%9d%1s",i,++count%10?"":"\n")
        }
      }
    }
    printf("\n%d-%d: %d primes, %d ascending primes\n",start,stop,primes,count)
    exit(0)
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
