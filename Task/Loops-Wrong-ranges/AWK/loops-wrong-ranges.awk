# syntax: GAWK -f LOOPS_WRONG_RANGES.AWK
BEGIN {
    arr[++n] = "-2, 2, 1,Normal"
    arr[++n] = "-2, 2, 0,Zero increment"
    arr[++n] = "-2, 2,-1,Increments away from stop value"
    arr[++n] = "-2, 2,10,First increment is beyond stop value"
    arr[++n] = " 2,-2, 1,Start more than stop: positive increment"
    arr[++n] = " 2, 2, 1,Start equal stop: positive increment"
    arr[++n] = " 2, 2,-1,Start equal stop: negative increment"
    arr[++n] = " 2, 2, 0,Start equal stop: zero increment"
    arr[++n] = " 0, 0, 0,Start equal stop equal zero: zero increment"
    print("start,stop,increment,comment")
    for (i=1; i<=n; i++) {
      split(arr[i],A,",")
      printf("%-52s : ",arr[i])
      count = 0
      for (j=A[1]; j<=A[2] && count<10; j+=A[3]) {
        printf("%d ",j)
        count++
      }
      printf("\n")
    }
    exit(0)
}
