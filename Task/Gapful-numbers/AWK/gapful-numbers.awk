# syntax: GAWK -f GAPFUL_NUMBERS.AWK
# converted from C++
BEGIN {
    show_gapful(100,30)
    show_gapful(1000000,15)
    show_gapful(1000000000,10)
    show_gapful(7123,25)
    exit(0)
}
function is_gapful(n,  m) {
    m = n
    while (m >= 10) {
      m = int(m / 10)
    }
    return(n % ((n % 10) + 10 * (m % 10)) == 0)
}
function show_gapful(n,  count,i) {
    printf("first %d gapful numbers >= %d:",count,n)
    for (i=0; i<count; n++) {
      if (is_gapful(n)) {
        printf(" %d",n)
        i++
      }
    }
    printf("\n")
}
