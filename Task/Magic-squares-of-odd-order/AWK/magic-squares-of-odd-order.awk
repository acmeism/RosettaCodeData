# syntax: GAWK -f MAGIC_SQUARES_OF_ODD_ORDER.AWK
BEGIN {
    build(5)
    build(3,1) # verify sum
    build(7)
    exit(0)
}
function build(n,check,  arr,i,width,x,y) {
    if (n !~ /^[0-9]*[13579]$/ || n < 3) {
      printf("error: %s is invalid\n",n)
      return
    }
    printf("\nmagic constant for %dx%d is %d\n",n,n,(n*n+1)*n/2)
    x = 0
    y = int(n/2)
    for (i=1; i<=(n*n); i++) {
      arr[x,y] = i
      if (arr[(x+n-1)%n,(y+n+1)%n]) {
        x = (x+n+1) % n
      }
      else {
        x = (x+n-1) % n
        y = (y+n+1) % n
      }
    }
    width = length(n*n)
    for (x=0; x<n; x++) {
      for (y=0; y<n; y++) {
        printf("%*s ",width,arr[x,y])
      }
      printf("\n")
    }
    if (check) { verify(arr,n) }
}
function verify(arr,n,  total,x,y) { # verify sum of each row, column and diagonal
    print("\nverify")
# horizontal
    for (x=0; x<n; x++) {
      total = 0
      for (y=0; y<n; y++) {
        printf("%d ",arr[x,y])
        total += arr[x,y]
      }
      printf("\t: %d row %d\n",total,x+1)
    }
# vertical
    for (y=0; y<n; y++) {
      total = 0
      for (x=0; x<n; x++) {
        printf("%d ",arr[x,y])
        total += arr[x,y]
      }
      printf("\t: %d column %d\n",total,y+1)
    }
# left diagonal
    total = 0
    for (x=y=0; x<n; x++ y++) {
      printf("%d ",arr[x,y])
      total += arr[x,y]
    }
    printf("\t: %d diagonal top left to bottom right\n",total)
# right diagonal
    x = n - 1
    total = 0
    for (y=0; y<n; y++ x--) {
      printf("%d ",arr[x,y])
      total += arr[x,y]
    }
    printf("\t: %d diagonal bottom left to top right\n",total)
}
