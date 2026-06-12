# syntax: GAWK -f SORT_PRIMES_FROM_LIST_TO_A_LIST.AWK
BEGIN {
    PROCINFO["sorted_in"] = "@val_num_asc"
    split("2,43,81,122,63,13,7,95,103",arr,",")
    for (i in arr) {
      if (is_prime(arr[i])) {
        printf("%d ",arr[i])
      }
    }
    printf("\n")
    exit(0)
}
function is_prime(n,  d) {
    d = 5
    if (n < 2) { return(0) }
    if (n % 2 == 0) { return(n == 2) }
    if (n % 3 == 0) { return(n == 3) }
    while (d*d <= n) {
      if (n % d == 0) { return(0) }
      d += 2
      if (n % d == 0) { return(0) }
      d += 4
    }
    return(1)
}
