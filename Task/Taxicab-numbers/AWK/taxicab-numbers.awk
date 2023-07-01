# syntax: GAWK -f TAXICAB_NUMBERS.AWK
BEGIN {
    stop = 99
    for (a=1; a<=stop; a++) {
      for (b=1; b<=stop; b++) {
        n1 = a^3 + b^3
        for (c=1; c<=stop; c++) {
          if (a == c) { continue }
          for (d=1; d<=stop; d++) {
            n2 = c^3 + d^3
            if (n1 == n2 && (a != d || b != c)) {
              if (n1 in arr) { continue }
              arr[n1] = sprintf("%7d = %2d^3 + %2d^3 = %2d^3 + %2d^3",n1,a,b,c,d)
            }
          }
        }
      }
    }
    PROCINFO["sorted_in"] = "@ind_num_asc"
    for (i in arr) {
      if (++count <= 25) {
        printf("%2d: %s\n",count,arr[i])
      }
    }
    printf("\nThere are %d taxicab numbers using bounds of %d\n",length(arr),stop)
    exit(0)
}
