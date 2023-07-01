# syntax: GAWK -f MULTIFACTORIAL.AWK
# converted from Go
BEGIN {
    for (k=1; k<=5; k++) {
      printf("degree %d:",k)
      for (n=1; n<=10; n++) {
        printf(" %d",multi_factorial(n,k))
      }
      printf("\n")
    }
    exit(0)
}
function multi_factorial(n,k,  r) {
    r = 1
    for (; n>1; n-=k) {
      r *= n
    }
    return(r)
}
