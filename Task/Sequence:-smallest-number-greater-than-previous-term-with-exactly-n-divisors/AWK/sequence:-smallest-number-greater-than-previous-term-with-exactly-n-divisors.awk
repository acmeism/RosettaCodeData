# syntax: GAWK -f SEQUENCE_SMALLEST_NUMBER_GREATER_THAN_PREVIOUS_TERM_WITH_EXACTLY_N_DIVISORS.AWK
# converted from Kotlin
BEGIN {
    limit = 15
    printf("first %d terms:",limit)
    n = 1
    while (n <= limit) {
      if (n == count_divisors(++i)) {
        printf(" %d",i)
        n++
      }
    }
    printf("\n")
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
