# syntax: GAWK -f SUB-UNIT_SQUARES.AWK
# converted from FreeBASIC
BEGIN {
    n = 1
    while (count <= 7) {
      n2 = n * n
      if (!has_zero(n2)) {
        m2 = dec_digits(n2)
        m = int(sqrt(m2))
        if (m * m == m2) {
          printf("%d ",n2)
          count++
        }
      }
      n++
    }
    printf("\n")
    exit(0)
}
function dec_digits(n,  m,t) {
    m = 11111111111
    while (1) {
      t = n - m
      m = int(m/10)
      if (t >= 0) {
        break
      }
    }
    return(t)
}
function has_zero(n) {
    return(n ~ "0" ? 1 : 0)
}
