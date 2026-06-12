# syntax: GAWK -f SUM_OF_DIVISORS.AWK
# converted from Go
BEGIN {
    limit = 100
    printf("The sums of positive divisors for the first %d positive integers are:\n",limit)
    for (i=1; i<=limit; i++) {
      printf("%3d ",sum_divisors(i))
      if (i % 10 == 0) {
        printf("\n")
      }
    }
    exit(0)
}
function sum_divisors(n,  ans,i,j,k) {
    ans = 0
    i = 1
    k = (n % 2 == 0) ? 1 : 2
    while (i*i <= n) {
      if (n % i == 0) {
        ans += i
        j = n / i
        if (j != i) {
          ans += j
        }
      }
      i += k
    }
    return(ans)
}
