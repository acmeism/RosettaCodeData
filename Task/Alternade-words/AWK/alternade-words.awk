# syntax: GAWK -f ALTERNADE_WORDS.AWK unixdict.txt
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
{ arr[$0]++ }
END {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (word in arr) {
      leng = length(word)
      if (leng < 6) {
        continue
      }
      odd_word = even_word = ""
      for (i=1; i<=leng; i++) {
        if (i ~ /[13579]$/) {
          odd_word = odd_word substr(word,i,1)
        }
        else {
          even_word = even_word substr(word,i,1)
        }
      }
      if (odd_word in arr && even_word in arr) {
        printf("%-9s %-5s %-5s\n",word,odd_word,even_word)
      }
    }
    exit(0)
}
