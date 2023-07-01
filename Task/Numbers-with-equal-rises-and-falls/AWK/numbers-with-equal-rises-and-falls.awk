# syntax: GAWK -f NUMBERS_WITH_EQUAL_RISES_AND_FALLS.AWK
# converted from Go
BEGIN {
    print("1-200:")
    while (1) {
      if (rises_equals_falls(++n)) {
        if (++count <= 200) {
          printf("%4d",n)
          if (count % 20 == 0) {
            printf("\n")
          }
        }
        if (count == 1E7) {
          printf("\n%d: %d",count,n)
          break
        }
      }
    }
    exit(0)
}
function rises_equals_falls(n,  d,falls,prev,rises) {
    if (n < 10) {
      return(1)
    }
    prev = -1
    while (n > 0) {
      d = n % 10
      if (prev >= 0) {
        if (d < prev) {
          rises++
        }
        else if (d > prev) {
          falls++
        }
      }
      prev = d
      n = int(n / 10)
    }
    return(rises == falls)
}
