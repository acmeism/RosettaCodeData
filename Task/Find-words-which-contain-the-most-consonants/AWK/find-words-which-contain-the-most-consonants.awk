# syntax: GAWK -f FIND_WORDS_WHICH_CONTAINS_MOST_CONSONANTS.AWK unixdict.txt
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    a2z = "abcdefghijklmnopqrstuvwxyz"
    gsub(/[aeiou]/,"",a2z) # remove vowels
    leng = length(a2z)
}
{   if (length($0) <= 10) {
      next
    }
    consonants = 0
    for (i=1; i<=leng; i++) {
      c = substr(a2z,i,1)
      if (gsub(c,"&",$0) > 1) {
        next
      }
      if (gsub(c,"&",$0) == 1) {
        consonants++
      }
    }
    arr[consonants][$0] = ""
    words++
}
END {
    show = 4
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (i in arr) {
      printf("%1d %3d ",i,length(arr[i]))
      shown = 0
      for (j in arr[i]) {
        if (++shown <= show) {
          printf("%s ",j)
        }
      }
      printf("%s\n",(length(arr[i])>show)?(" ...  "j):"")
    }
    printf("%5d words\n",words)
    exit(0)
}
