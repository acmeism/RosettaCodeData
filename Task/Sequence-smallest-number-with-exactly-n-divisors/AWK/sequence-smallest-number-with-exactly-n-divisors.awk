# syntax: GAWK -f SEQUENCE_SMALLEST_NUMBER_WITH_EXACTLY_N_DIVISORS.AWK
# converted from Kotlin
BEGIN {
    limit = 15
    printf("first %d terms:",limit)
    i = 1
    n = 0
    while (n < limit) {
      k = count_divisors(i)
      if (k <= limit && seq[k-1]+0 == 0) {
        seq[k-1] = i
        n++
      }
      i++
    }
    for (i=0; i<limit; i++) {
      printf(" %d",seq[i])
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
