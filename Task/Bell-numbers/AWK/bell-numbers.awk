# syntax: GAWK --bignum -f BELL_NUMBERS.AWK
BEGIN {
    arr[0,0] = 1
    printf(" 0: %10d\n",arr[0,0])
    printf(" 1: %10d\n",arr[0,0])
    for (i=1; i<50; i++) {
      arr[i,0] = arr[i-1,i-1]
      for (j=1; j<=i; j++) {
        arr[i,j] = arr[i,j-1] + arr[i-1,j-1]
        bt[i] = sprintf("%s%s ",bt[i],arr[i-1,j-1]) # build Bell's triangle
      }
      if (i <= 13) {
        printf("%2d: %10d\n",i+1,arr[i,i])
      }
      if (i == 49) {
        printf("%2d: %d (%d digits)\n\n",i+1,arr[i,i],length(arr[i,i]))
      }
    }
    for (i=1; i<=10; i++) { # show Bell's triangle
      printf("%2d: %s\n",i,bt[i])
    }
    exit(0)
}
