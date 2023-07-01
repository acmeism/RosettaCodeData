# syntax: GAWK -f PYTHAGOREAN_QUADRUPLES.AWK
# converted from Go
BEGIN {
    n = 2200
    s = 3
    for (a=1; a<=n; a++) {
      a2 = a * a
      for (b=a; b<=n; b++) {
        ab[a2 + b * b] = 1
      }
    }
    for (c=1; c<=n; c++) {
      s1 = s
      s += 2
      s2 = s
      for (d=c+1; d<=n; d++) {
        if (ab[s1]) {
          r[d] = 1
        }
        s1 += s2
        s2 += 2
      }
    }
    for (d=1; d<=n; d++) {
      if (!r[d]) {
        printf("%d ",d)
      }
    }
    printf("\n")
    exit(0)
}
