# syntax: GAWK -f MINIMUM_NUMBERS_OF_THREE_LISTS.AWK
BEGIN {
    n1 = split("5,45,23,21,67",numbers1,",")
    n2 = split("43,22,78,46,38",numbers2,",")
    n3 = split("9,98,12,98,53",numbers3,",")
    if (n1 != n2 || n1 != n3) {
      print("error: arrays must be same length")
      exit(1)
    }
    for (i=1; i<=n1; i++) {
      numbers[i] = min(min(numbers1[i],numbers2[i]),numbers3[i])
      printf("%d ",numbers[i])
    }
    printf("\n")
    exit(0)
}
function min(x,y) { return((x < y) ? x : y) }
