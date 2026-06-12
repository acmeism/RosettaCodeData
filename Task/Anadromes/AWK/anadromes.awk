# syntax: GAWK -f ANADROMES.AWK WORDS.TXT
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    width = 6
}
{   if (length($0) > width) {
      arr[$0]++
    }
}
END {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (i in arr) {
      tmp = reverse(i)
      if (tmp in arr) {
        if (i == tmp) { continue }
        if (tmp in shown_arr) { continue }
        printf("%11s %11s\n",i,tmp)
        shown_arr[i] = ""
      }
    }
    printf("%d words, %d > %d characters, %d anadromes\n",NR,length(arr),width,length(shown_arr))
    exit(0)
}
function reverse(str,  i,rts) {
    for (i=length(str); i>=1; i--) {
      rts = rts substr(str,i,1)
    }
    return(rts)
}
