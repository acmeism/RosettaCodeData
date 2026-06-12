# syntax: GAWK -f MINIMUM_NUMBER_OF_CELLS_AFTER_BEFORE_ABOVE_AND_BELOW_NXN_SQUARES.AWK
BEGIN {
    leng = split("3,4,9,10,23",arr,",")
    for (k=1; k<=leng; k++) {
      n = arr[k]
      printf("\nDistance to nearest edge: %dx%d\n",n,n)
      for (i=1; i<=n; i++) {
        for (j=1; j<=n; j++) {
          printf("%2d ",min(min(i-1,n-i),min(j-1,n-j)))
        }
        printf("\n")
      }
    }
    exit(0)
}
function min(x,y) { return((x < y) ? x : y) }
