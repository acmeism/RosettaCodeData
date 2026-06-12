# syntax: GAWK -f 10001TH_PRIME.AWK

BEGIN {
    printf("%s\n",main(10001))
    exit(0)
}
function main(n,  p,pn) {
    if (n == 1) { return(2) }
    p = 3
    pn = 1
    while (pn < n) {
      if (is_prime(p)) {
        pn++
      }
      p += 2
    }
    return(p-2)
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
