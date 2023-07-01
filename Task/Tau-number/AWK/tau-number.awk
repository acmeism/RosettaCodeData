# syntax: GAWK -f TAU_NUMBER.AWK
BEGIN {
    print("The first 100 tau numbers:")
    while (count < 100) {
      i++
      if (i % count_divisors(i) == 0) {
        printf("%4d ",i)
        if (++count % 10 == 0) {
          printf("\n")
        }
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
