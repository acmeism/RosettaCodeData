# syntax: GAWK -f SORT_USING_A_CUSTOM_COMPARATOR.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    words = "This Is A Set Of Strings To Sort duplicated"
    n = split(words " " tolower(words),tmp_arr," ")
    print("unsorted:")
    for (i=1; i<=n; i++) {
      word = tmp_arr[i]
      arr[length(word)][word]++
      print(word)
    }
    print("\nsorted:")
    PROCINFO["sorted_in"] = "@ind_num_desc" ; SORTTYPE = 9
    for (i in arr) {
      PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 2
      for (j in arr[i]) {
        for (k=1; k<=arr[i][j]; k++) {
          print(j)
        }
      }
    }
    exit(0)
}
