# syntax: GAWK -f PERMUTATIONS_WITH_REPETITIONS.AWK
# converted from C
BEGIN {
    numbers = 3
    upto = 4
    for (tmp2=1; tmp2<=numbers; tmp2++) {
      arr[tmp2] = 1
    }
    arr[numbers] = 0
    tmp1 = numbers
    while (1) {
      if (arr[tmp1] == upto) {
        if (--tmp1 == 0) {
          break
        }
      }
      else {
        arr[tmp1]++
        while (tmp1 < numbers) {
          arr[++tmp1] = 1
        }
        printf("(")
        for (tmp2=1; tmp2<=numbers; tmp2++) {
          printf("%d",arr[tmp2])
        }
        printf(")")
      }
    }
    printf("\n")
    exit(0)
}
