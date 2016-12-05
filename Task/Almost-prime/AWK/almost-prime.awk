# syntax: GAWK -f ALMOST_PRIME.AWK
BEGIN {
    for (k=1; k<=5; k++) {
      printf("%d:",k)
      c = 0
      i = 1
      while (c < 10) {
        if (kprime(++i,k)) {
          printf(" %d",i)
          c++
        }
      }
      printf("\n")
    }
    exit(0)
}
function kprime(n,k,  f,p) {
    for (p=2; f<k && p*p<=n; p++) {
      while (n % p == 0) {
        n /= p
        f++
      }
    }
    return(f + (n > 1) == k)
}
