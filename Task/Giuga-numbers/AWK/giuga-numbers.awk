# syntax: GAWK -f GIUGA_NUMBER.AWK
BEGIN {
    n = 3
    stop = 4
    printf("Giuga numbers 1-%d:",stop)
    while (count < stop) {
      if (is_giuga(n)) {
        count++
        printf(" %d",n)
      }
      n++
    }
    printf("\n")
    exit(0)
}
function is_giuga(m,  f,l,n) {
    n = m
    f = 2
    l = sqrt(n)
    while (1) {
      if (n % f == 0) {
        if (((m / f) - 1) % f != 0) { return(0) }
        n /= f
        if (f > n) { return(1) }
      }
      else {
        if (++f > l) { return(0) }
      }
    }
}
