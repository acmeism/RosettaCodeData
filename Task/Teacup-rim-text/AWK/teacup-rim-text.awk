# syntax: GAWK -f TEACUP_RIM_TEXT.AWK UNIXDICT.TXT
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
{   for (i=1; i<=NF; i++) {
      arr[tolower($i)] = 0
    }
}
END {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (i in arr) {
      leng = length(i)
      if (leng > 2) {
        delete tmp_arr
        words = str = i
        tmp_arr[i] = ""
        for (j=2; j<=leng; j++) {
          str = substr(str,2) substr(str,1,1)
          if (str in arr) {
            words = words " " str
            tmp_arr[str] = ""
          }
        }
        if (length(tmp_arr) == leng) {
          count = 0
          for (j in tmp_arr) {
            (arr[j] == 0) ? arr[j]++ : count++
          }
          if (count == 0) {
            printf("%s\n",words)
            circular++
          }
        }
      }
    }
    printf("%d words, %d circular\n",length(arr),circular)
    exit(0)
}
