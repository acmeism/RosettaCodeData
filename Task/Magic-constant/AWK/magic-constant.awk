# syntax: GAWK -f MAGIC_CONSTANT.AWK
# converted from FreeBASIC
BEGIN {
    printf("The first 20 magic constants are:")
    for (i=1; i<=20; i++) {
      printf(" %d",a(i))
    }
    printf("\n")
    printf("The 1,000th magic constant is: %d\n",a(1000))
    for (i=1; i<=20; i++) {
      printf("10^%02d: %8d\n",i,inv_a(10^i))
    }
    exit(0)
}
function a(n) {
    n += 2
    return(n*(n^2+1)/2)
}
function inv_a(x,  k) {
    while (k*(k^2+1)/2+2 < x) {
      k++
    }
    return(k)
}
