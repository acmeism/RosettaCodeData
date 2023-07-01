# syntax: GAWK -f STRONG_AND_WEAK_PRIMES.AWK
BEGIN {
    for (i=1; i<1E7; i++) {
      if (is_prime(i)) {
        arr[++n] = i
      }
    }
# strong:
    stop1 = 36 ; stop2 = 1E6 ; stop3 = 1E7
    count1 = count2 = count3 = 0
    printf("The first %d strong primes:",stop1)
    for (i=2; count1<stop1; i++) {
      if (arr[i] > (arr[i-1] + arr[i+1]) / 2) {
        count1++
        printf(" %d",arr[i])
      }
    }
    printf("\n")
    for (i=2; i<stop3; i++) {
      if (arr[i] > (arr[i-1] + arr[i+1]) / 2) {
        count3++
        if (arr[i] < stop2) {
          count2++
        }
      }
    }
    printf("Number below %d: %d\n",stop2,count2)
    printf("Number below %d: %d\n",stop3,count3)
# weak:
    stop1 = 37 ; stop2 = 1E6 ; stop3 = 1E7
    count1 = count2 = count3 = 0
    printf("The first %d weak primes:",stop1)
    for (i=2; count1<stop1; i++) {
      if (arr[i] < (arr[i-1] + arr[i+1]) / 2) {
        count1++
        printf(" %d",arr[i])
      }
    }
    printf("\n")
    for (i=2; i<stop3; i++) {
      if (arr[i] < (arr[i-1] + arr[i+1]) / 2) {
        count3++
        if (arr[i] < stop2) {
          count2++
        }
      }
    }
    printf("Number below %d: %d\n",stop2,count2)
    printf("Number below %d: %d\n",stop3,count3)
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
