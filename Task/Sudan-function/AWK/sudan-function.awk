# syntax: GAWK -f SUDAN_FUNCTION.AWK
BEGIN {
    for (n=0; n<=1; n++) {
      printf("sudan(%d,x,y)\n",n)
      printf("y/x    0   1   2   3   4   5\n")
      printf("%s\n",strdup("-",28))
      for (y=0; y<=6; y++) {
        printf("%2d | ",y)
        for (x=0; x<=5; x++) {
          printf("%3d ",sudan(n,x,y))
        }
        printf("\n")
      }
      printf("\n")
    }
    n=1; x=3; y=3; printf("sudan(%d,%d,%d)=%d\n",n,x,y,sudan(n,x,y))
    n=2; x=1; y=1; printf("sudan(%d,%d,%d)=%d\n",n,x,y,sudan(n,x,y))
    n=2; x=2; y=1; printf("sudan(%d,%d,%d)=%d\n",n,x,y,sudan(n,x,y))
    n=3; x=1; y=1; printf("sudan(%d,%d,%d)=%d\n",n,x,y,sudan(n,x,y))
    exit(0)
}
function sudan(n,x,y) {
    if (n == 0) { return(x+y) }
    if (y == 0) { return(x) }
    return sudan(n-1, sudan(n,x,y-1), sudan(n,x,y-1)+y)
}
function strdup(str,n,  i,new_str) {
    for (i=1; i<=n; i++) {
      new_str = new_str str
    }
    return(new_str)
}
