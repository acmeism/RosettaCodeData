# syntax: GAWK -f PIERPONT_PRIMES.AWK
# converted from FreeBASIC
BEGIN {
    NPP = 50
    x = 1
    while (np[1] <= NPP || np[2] <= NPP) {
      x++
      j = is_pierpont(x)
      if (j > 0) {
        if (j % 2 == 1) {
          np[1]++
          if (np[1] <= NPP) { arr[1][np[1]] = x }
        }
        if (j > 1) {
          np[2]++
          if (np[2] <= NPP) { arr[2][np[2]] = x }
        }
      }
    }
    printf("\nFirst %d Pierpont primes of the first kind:\n",NPP)
    for (j=1; j<=NPP; j++) {
      printf("%9d%s",arr[2][j],j%10?"":"\n")
    }
    printf("\n\nFirst %d Pierpont primes of the second kind:\n",NPP)
    for (j=1; j<=NPP; j++) {
      printf( "%9d%s",arr[1][j],j%10?"":"\n")
    }
    printf("\n")
    exit(0)
}
function is_23(n) {
    while (n % 2 == 0) {
      n = int(n/2)
    }
    while (n % 3 == 0) {
      n = int(n/3)
    }
    return(n==1 ? 1 : 0)
}
function is_pierpont(n,  p1,p2) {
    if (!is_prime(n)) { return(0) }    # not prime
    p1 = is_23(n+1)
    p2 = is_23(n-1)
    if (p1 && p2) { return(3) }        # pierpont prime of both kinds
    if (p1) { return(1) }              # pierpont prime of the 1st kind
    if (p2) { return(2) }              # pierpont prime of the 2nd kind
    return(0)                          # prime, but not pierpont
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
