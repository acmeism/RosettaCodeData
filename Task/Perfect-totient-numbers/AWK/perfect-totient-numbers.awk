# syntax: GAWK -f PERFECT_TOTIENT_NUMBERS.AWK
BEGIN {
    i = 20
    printf("The first %d perfect totient numbers:\n%s\n",i,perfect_totient(i))
    exit(0)
}
function perfect_totient(n,  count,m,str,sum,tot) {
    for (m=1; count<n; m++) {
      tot = m
      sum = 0
      while (tot != 1) {
        tot = totient(tot)
        sum += tot
      }
      if (sum == m) {
        str = str m " "
        count++
      }
    }
    return(str)
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
