# syntax: GAWK -f GETTING_THE_NUMBER_OF_DECIMALS.AWK
BEGIN {
    n = split("10,1.,1.0,12.345,12.3450",arr,",")
    for (i=1; i<=n; i++) {
      s = arr[i]
      x = index(s,".")
      printf("%s has %d decimals\n",s,x?length(s)-x:x)
    }
    exit(0)
}
