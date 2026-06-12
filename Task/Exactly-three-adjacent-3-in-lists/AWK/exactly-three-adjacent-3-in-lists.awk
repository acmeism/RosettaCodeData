# syntax: GAWK -f EXACTLY_THREE_ADJACENT_3_IN_LISTS.AWK
BEGIN {
    list[++n] = "9,3,3,3,2,1,7,8,5"
    list[++n] = "5,2,9,3,3,7,8,4,1"
    list[++n] = "1,4,3,6,7,3,8,3,2"
    list[++n] = "1,2,3,4,5,6,7,8,9"
    list[++n] = "4,6,8,7,2,3,3,3,1"
    for (i=1; i<=n; i++) {
      tmp = "," list[i] ","
      printf("%s %s\n",sub(/,3,3,3,/,"",tmp)?"T":"F",list[i])
    }
    exit(0)
}
