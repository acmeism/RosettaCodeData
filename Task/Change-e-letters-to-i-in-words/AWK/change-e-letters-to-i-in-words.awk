# syntax: GAWK -f CHANGE_E_LETTERS_TO_I_IN_WORDS.AWK unixdict.txt
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
{   if (length($0) < 6) {
      next
    }
    arr1[$0] = ""
}
END {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (i in arr1) {
      word = i
      if (gsub(/e/,"i",word) > 0) {
        if (word in arr1) {
          arr2[i] = word
        }
      }
    }
    for (i in arr2) {
      printf("%-9s %s\n",i,arr2[i])
    }
    exit(0)
}
