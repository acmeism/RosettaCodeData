# syntax: GAWK -f SATTOLO_CYCLE.AWK
BEGIN {
    srand()
    main("")
    main("10")
    main("10,20")
    main("10,20,30")
    main("11,12,13,14,15,16,17,18,19,20,21,22")
    main("it's,July,4th,happy,birthday,usa")
    exit(0)
}
function main(str,  i,n) {
    n = split(str,arr,",")
    printf("bef:")
    for (i=1; i<=n; i++) {
      printf(" %s",arr[i])
      arr[i-1] = arr[i] # make array start with C's 0 instead of AWK's 1
    }
    printf("\n")
    if (n > 0) {
      delete arr[n--]
    }
    sattolo_cycle(n)
    printf("aft:")
    for (i=0; i<=n; i++) {
      printf(" %s",arr[i])
    }
    printf("\n\n")
}
function sattolo_cycle(n,  i,j,tmp) {
     if (n < 1) {
       return
     }
     for (i=n; i>=1; i--) {
      j = floor(rand() * i)
      tmp = arr[i]
      arr[i] = arr[j]
      arr[j] = tmp
    }
}
function floor(x, y) { y=int(x) ; return (y>x)?y-1:y }
