# syntax: GAWK -f LAH_NUMBERS.AWK
# converted from C
BEGIN {
    print("unsigned Lah numbers: L(n,k)")
    printf("n/k")
    for (i=0; i<13; i++) {
      printf("%11d",i)
    }
    printf("\n")
    for (row=0; row<13; row++) {
      printf("%-3d",row)
      for (i=0; i<row+1; i++) {
        printf(" %10d",lah(row,i))
      }
      printf("\n")
    }
    exit(0)
}
function factorial(n,  res) {
    res = 1
    if (n == 0) { return(res) }
    while (n > 0) { res *= n-- }
    return(res)
}
function lah(n,k) {
    if (k == 1) { return factorial(n) }
    if (k == n) { return(1) }
    if (k > n) { return(0) }
    if (k < 1 || n < 1) { return(0) }
    return (factorial(n) * factorial(n-1)) / (factorial(k) * factorial(k-1)) / factorial(n-k)
}
