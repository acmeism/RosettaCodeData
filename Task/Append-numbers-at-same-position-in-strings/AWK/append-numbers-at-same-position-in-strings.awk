# syntax: GAWK -f APPEND_NUMBERS_AT_SAME_POSITION_IN_STRINGS.AWK
BEGIN {
    n1 = split("1,2,3,4,5,6,7,8,9",list1,",")
    n2 = split("10,11,12,13,14,15,16,17,18",list2,",")
    n3 = split("19,20,21,22,23,24,25,26,27",list3,",")
    if (n1 != n2 || n1 != n3) {
      print("error: arrays must be same length")
      exit(1)
    }
    for (i=1; i<=n1; i++) {
      list[i] = list1[i] list2[i] list3[i]
      printf("%s ",list[i])
    }
    printf("\n")
    exit(0)
}
