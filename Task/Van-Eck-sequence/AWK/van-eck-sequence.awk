# syntax: GAWK -f VAN_ECK_SEQUENCE.AWK
# converted from Go
BEGIN {
    limit = 1000
    for (i=0; i<limit; i++) {
      arr[i] = 0
    }
    for (n=0; n<limit-1; n++) {
      for (m=n-1; m>=0; m--) {
        if (arr[m] == arr[n]) {
          arr[n+1] = n - m
          break
        }
      }
    }
    printf("terms 1-10:")
    for (i=0; i<10; i++) { printf(" %d",arr[i]) }
    printf("\n")
    printf("terms 991-1000:")
    for (i=990; i<1000; i++) { printf(" %d",arr[i]) }
    printf("\n")
    exit(0)
}
