# syntax: GAWK -f TOTIENT_FUNCTION.AWK
BEGIN {
    print(" N Phi isPrime")
    for (n=1; n<=1000000; n++) {
      tot = totient(n)
      if (n-1 == tot) {
        count++
      }
      if (n <= 25) {
        printf("%2d %3d %s\n",n,tot,(n-1==tot)?"true":"false")
        if (n == 25) {
          printf("\n  Limit PrimeCount\n")
          printf("%7d %10d\n",n,count)
        }
      }
      else if (n ~ /^100+$/) {
        printf("%7d %10d\n",n,count)
      }
    }
    exit(0)
}
function totient(n,  i,tot) {
    tot = n
    for (i=2; i*i<=n; i+=2) {
      if (n % i == 0) {
        while (n % i == 0) {
          n /= i
        }
        tot -= tot / i
      }
      if (i == 2) {
        i = 1
      }
    }
    if (n > 1) {
      tot -= tot / n
    }
    return(tot)
}
