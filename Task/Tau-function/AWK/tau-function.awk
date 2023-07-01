# syntax: GAWK -f TAU_FUNCTION.AWK
BEGIN {
    print("The tau functions for the first 100 positive integers:")
    for (i=1; i<=100; i++) {
      printf("%2d ",count_divisors(i))
      if (i % 10 == 0) {
        printf("\n")
      }
    }
    exit(0)
}
function count_divisors(n,  count,i) {
    for (i=1; i*i<=n; i++) {
      if (n % i == 0) {
        count += (i == n / i) ? 1 : 2
      }
    }
    return(count)
}
