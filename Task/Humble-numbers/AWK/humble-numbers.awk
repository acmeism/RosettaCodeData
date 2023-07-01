# syntax: GAWK -f HUMBLE_NUMBERS.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    PROCINFO["sorted_in"] = "@ind_num_asc" ; SORTTYPE = 1
    n = 1
    for (; count<5193; n++) {
      if (is_humble(n)) {
        arr[length(n)]++
        if (count++ < 50) {
          printf("%d ",n)
        }
      }
    }
    printf("\nCount Digits of the first %d humble numbers:\n",count)
    for (i in arr) {
      printf("%5d %6d\n",arr[i],i)
    }
    exit(0)
}
function is_humble(i) {
    if (i <= 1) { return(1) }
    if (i % 2 == 0) { return(is_humble(i/2)) }
    if (i % 3 == 0) { return(is_humble(i/3)) }
    if (i % 5 == 0) { return(is_humble(i/5)) }
    if (i % 7 == 0) { return(is_humble(i/7)) }
    return(0)
}
