# syntax: GAWK -f ROUND-ROBIN_TOURNAMENT_SCHEDULE.AWK
BEGIN {
    main(1)
    main(2)
    main(5,"The Bizzaros")
    main(12)
    exit(0)
}
function main(n,description,  arr,i,j,leng,tmp) {
    if (n < 2) {
      printf("\n%d is too few participants\n",n)
      return
    }
    printf("\n%d players  %s\n",n,description)
    for (i=1; i<=n; i++) {
      arr[i] = i
    }
    if (n % 2 == 1) {
      arr[++n] = 0 # a "bye"
    }
    leng = length(n-1)
    for (i=1; i<n; i++) {
      printf("\nround %*d:",leng,i)
      for (j=1; j<=n/2; j++) {
        printf("%4s",arr[j]==0?"bye":arr[j])
      }
      printf("\n%*s",leng+7,"")
      for (j=n; j>n/2; j--) {
        printf("%4s",arr[j]==0?"bye":arr[j])
      }
      printf("\n")
      tmp = arr[n]
      for (j=n; j>2; j--) {
        arr[j] = arr[j-1]
      }
      arr[2] = tmp
    }
}
