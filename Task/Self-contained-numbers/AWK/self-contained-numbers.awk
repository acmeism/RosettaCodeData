# syntax: GAWK -f SELF-CONTAINED_NUMBERS.AWK
# converted from C
BEGIN {
    i = 1
    while (count < 7) {
      j = i
      while (j != 1) {
        if (j % 2 == 0) {
          j /= 2
        }
        else {
          j = 3 * j + 1
        }
        if (j % i == 0) {
          printf("%d ",i)
          count++
          break
        }
      }
      i += 2
    }
    printf("\n")
    exit(0)
}
