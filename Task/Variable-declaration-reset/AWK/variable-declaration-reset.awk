# syntax: GAWK -f VARIABLE_DECLARATION_RESET.AWK
BEGIN {
    n = split("1,2,2,3,4,4,5",arr,",")
    for (i=1; i<=n; i++) {
      curr = arr[i]
      if (i > 1 && prev == curr) {
        printf("%s\n",i)
      }
      prev = curr
    }
    exit(0)
}
