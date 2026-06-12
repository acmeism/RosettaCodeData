# syntax: GAWK -f CHANGEABLE_WORDS.AWK unixdict.txt
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
{ arr[$0]++ }
END {
    a2z = "abcdefghijklmnopqrstuvwxyz"
    a2z_leng = length(a2z)
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (word in arr) {
      leng = length(word)
      if (leng < 12) {
        continue
      }
      printed = 0
      for (i=1; i<=leng; i++) {
        if (printed == 1) {
          break
        }
        if (i == 1) {
          L = ""
          R = substr(word,2)
        }
        else if (i == leng) {
          L = substr(word,1,leng-1)
          R = ""
        }
        else {
          L = substr(word,1,i)
          R = substr(word,i+2)
        }
        for (j=1; j<a2z_leng; j++) {
          new_word = L substr(a2z,j,1) R
          if (new_word in arr && word != new_word) {
            printf("%-15s %s\n",word,new_word)
            printed = 1
            count++
          }
        }
      }
    }
    printf("%d words\n",count)
    exit(0)
}
