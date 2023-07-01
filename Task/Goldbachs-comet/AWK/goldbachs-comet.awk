# syntax: GAWK -f GOLDBACHS_COMET.AWK
BEGIN {
    print("The first 100 G numbers:")
    for (n=4; n<=202; n+=2) {
      printf("%4d%1s",g(n),++count%10?"":"\n")
    }
    n = 1000000
    printf("\nG(%d): %d\n",n,g(n))
    n = 4
    printf("G(%d): %d\n",n,g(n))
    n = 22
    printf("G(%d): %d\n",n,g(n))
    exit(0)
}
function g(n,  count,i) {
    if (n % 2 == 0) { # n must be even
      for (i=2; i<=(1/2)*n; i++) {
        if (is_prime(i) && is_prime(n-i)) {
          count++
        }
      }
    }
    return(count)
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
