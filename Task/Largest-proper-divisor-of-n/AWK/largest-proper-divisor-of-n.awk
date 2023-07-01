# syntax: GAWK -f LARGEST_PROPER_DIVISOR_OF_N.AWK
# converted from C
BEGIN {
    start = 1
    stop = 100
    for (i=start; i<=stop; i++) {
      printf("%3d%1s",largest_proper_divisor(i),++count%10?"":"\n")
    }
    printf("\nLargest proper divisor of n %d-%d\n",start,stop)
    exit(0)
}
function largest_proper_divisor(n,  i) {
    if (n <= 1) {
      return(1)
    }
    for (i=n-1; i>0; i--) {
      if (n % i == 0) {
        return(i)
      }
    }
}
