# syntax: GAWK -f PRODUCT_OF_DIVISORS.AWK
# converted from Go
BEGIN {
    limit = 50
    printf("The products of positive divisors for the first %d positive integers are:\n",limit)
    for (i=1; i<=limit; i++) {
      printf("%12d ",product_divisors(i))
      if (i % 10 == 0) {
        printf("\n")
      }
    }
    exit(0)
}
function product_divisors(n,  ans,i,j,k) {
    ans = 1
    i = 1
    k = (n % 2 == 0) ? 1 : 2
    while (i*i <= n) {
      if (n % i == 0) {
        ans *= i
        j = n / i
        if (j != i) {
          ans *= j
        }
      }
      i += k
    }
    return(ans)
}
