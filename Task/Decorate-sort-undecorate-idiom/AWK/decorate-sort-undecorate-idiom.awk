# syntax: GAWK -f DECORATE-SORT-UNDECORATE_IDIOM.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    words = "Rosetta Code is a programming chrestomathy site"
    printf("bef: %s\n",words)
    width = 6
    n = split(words,words_arr," ")
    for (i=1; i<=n; i++) {
      tmp = sprintf("%0*d%0*d",width,length(words_arr[i]),width,++x)
      arr[tmp] = words_arr[i]
    }
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    printf("aft: ")
    for (i in arr) {
      printf("%s ",arr[i])
    }
    printf("\n")
    exit(0)
}
