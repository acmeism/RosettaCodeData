# syntax: GAWK -f RECAMANS_SEQUENCE.AWK
# converted from Microsoft Small Basic
BEGIN {
    found_dup = 0
    n = -1
    do {
      n++
      ap = a[n-1] + n
      if (a[n-1] <= n) {
        a[n] = ap
        b[ap] = 1
      }
      else {
        am = a[n-1] - n
        if (b[am] == 1) {
          a[n] = ap
          b[ap] = 1
        }
        else {
          a[n] = am
          b[am] = 1
        }
      }
      if (n <= 14) {
        terms = sprintf("%s%s ",terms,a[n])
        if (n == 14) {
          printf("first %d terms: %s\n",n+1,terms)
        }
      }
      if (!found_dup) {
        if (dup[a[n]] == 1) {
          printf("first duplicated term: a[%d]=%d\n",n,a[n])
          found_dup = 1
        }
        dup[a[n]] = 1
      }
      if (a[n] <= 1000) {
        arr[a[n]] = ""
      }
    } while (n <= 15 || !found_dup || length(arr) < 1001)
    printf("terms needed to generate integers 0 - 1000: %d\n",n)
    exit(0)
}
