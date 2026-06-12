# syntax: GAWK -f ODD_WORDS.AWK unixdict.txt
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
{ arr[$0]++ }
END {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    main("13579","odd")
    main("02468","even")
    exit(0)
}
function main(pattern,text,  i,tmp,word) {
    pattern = sprintf("[%s]$",pattern)
    printf("\n%s:\n",text)
    for (word in arr) {
      tmp = ""
      for (i=1; i<=length(word); i++) {
        if (i ~ pattern) {
          tmp = tmp substr(word,i,1)
        }
      }
      if (length(tmp) > 4 && tmp in arr) {
        printf("%-11s %s\n",word,tmp)
      }
    }
}
