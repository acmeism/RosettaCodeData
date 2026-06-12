# syntax: GAWK -f BERNOULLIS_TRIANGLE.AWK
# converted from Yabasic
BEGIN {
    for (n=0; n<=14; n++) {
      for (k=0; k<=n; k++) {
        if (k == 0) {
          row[k] = 1
        }
        else if (k < n) {
          row[k] = prev_row[k] + prev_row[k-1]
        }
        else {
          row[k] = 2^n
        }
      }
      for (k=0; k<=n; k++) {
        printf("%6d",row[k])
      }
      printf("\n")
      for (k=0; k<=n; k++) {
        prev_row[k] = row[k]
      }
    }
    exit(0)
}
