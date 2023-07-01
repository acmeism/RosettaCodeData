# syntax: GAWK -f MAGNANIMOUS_NUMBERS.AWK
# converted from C
BEGIN {
    magnanimous(1,45)
    magnanimous(241,250)
    magnanimous(391,400)
    exit(0)
}
function is_magnanimous(n,  p,q,r) {
    if (n < 10) { return(1) }
    for (p=10; ; p*=10) {
      q = int(n/p)
      r = n % p
      if (!is_prime(q+r)) { return(0) }
      if (q < 10) { break }
    }
    return(1)
}
function is_prime(n,  d) {
    d = 5
    if (n < 2) { return(0) }
    if (!(n % 2)) { return(n == 2) }
    if (!(n % 3)) { return(n == 3) }
    while (d*d <= n) {
      if (!(n % d)) { return(0) }
      d += 2
      if (!(n % d)) { return(0) }
      d += 4
    }
    return(1)
}
function magnanimous(start,stop,  count,i) {
    printf("%d-%d:",start,stop)
    for (i=0; count<stop; ++i) {
      if (is_magnanimous(i)) {
        if (++count >= start) {
          printf(" %d",i)
        }
      }
    }
    printf("\n")
}
