# syntax: GAWK -f ULAM_NUMBERS.AWK
BEGIN {
    u = split("1,2",ulam,",")
    for (n=3; ; n++) {
      count = 0
      for (x=1; x<=u-1; x++) {
        for (y=x+1; y<=u; y++) {
          if (ulam[x] + ulam[y] == n) {
            count++
          }
        }
      }
      if (count == 1) {
        ulam[++u] = n
        if (u ~ /^(10|50|100|500|1000)$/) {
          printf("%6d %6d\n",u,n)
          if (++shown >= 5) { break }
        }
      }
    }
    exit(0)
}
