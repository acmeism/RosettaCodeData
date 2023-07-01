# syntax: GAWK -f SAFE_PRIMES_AND_UNSAFE_PRIMES.AWK
BEGIN {
    for (i=1; i<1E7; i++) {
      if (is_prime(i)) {
        arr[i] = ""
      }
    }
# safe:
    stop1 = 35 ; stop2 = 1E6 ; stop3 = 1E7
    count1 = count2 = count3 = 0
    printf("The first %d safe primes:",stop1)
    for (i=3; count1<stop1; i+=2) {
      if (i in arr && ((i-1)/2 in arr)) {
        count1++
        printf(" %d",i)
      }
    }
    printf("\n")
    for (i=3; i<stop3; i+=2) {
      if (i in arr && ((i-1)/2 in arr)) {
        count3++
        if (i < stop2) {
          count2++
        }
      }
    }
    printf("Number below %d: %d\n",stop2,count2)
    printf("Number below %d: %d\n",stop3,count3)
# unsafe:
    stop1 = 40 ; stop2 = 1E6 ; stop3 = 1E7
    count1 = count2 = count3 = 1 # since (2-1)/2 is not prime
    printf("The first %d unsafe primes: 2",stop1)
    for (i=3; count1<stop1; i+=2) {
      if (i in arr && !((i-1)/2 in arr)) {
        count1++
        printf(" %d",i)
      }
    }
    printf("\n")
    for (i=3; i<stop3; i+=2) {
      if (i in arr && !((i-1)/2 in arr)) {
        count3++
        if (i < stop2) {
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
