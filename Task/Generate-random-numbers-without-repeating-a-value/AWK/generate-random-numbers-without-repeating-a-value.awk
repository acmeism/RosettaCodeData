# syntax: GAWK -f GENERATE_RANDOM_NUMBERS_WITHOUT_REPEATING_A_VALUE.AWK
BEGIN {
    limit = 20
    srand()
    printf("range 1-%d:",limit)
    while (count < limit) {
      n = sprintf("%d",int(rand()*limit)+1)
      if (!(n in arr)) {
        printf(" %d",n)
        arr[n] = ""
        count++
      }
    }
    printf("\n")
    exit(0)
}
