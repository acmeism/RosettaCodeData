# syntax: GAWK -f TRIPLET_OF_THREE_NUMBERS.AWK
BEGIN {
    start = 1
    stop = 6000
    print("   N   N-1  N+3  N+5")
    print("----- ---- ---- ----")
    for (i=start; i<=stop; i++) {
      if (is_prime(i-1) && is_prime(i+3) && is_prime(i+5)) {
        printf("%4d: %4d %4d %4d\n",i,i-1,i+3,i+5)
        count++
      }
    }
    printf("Triplet of three numbers %d-%d: %d\n",start,stop,count)
    exit(0)
}
function is_prime(x,  i) {
    if (x <= 1) {
      return(0)
    }
    for (i=2; i<=int(sqrt(x)); i++) {
      if (x % i == 0) {
        return(0)
      }
    }
    return(1)
}
