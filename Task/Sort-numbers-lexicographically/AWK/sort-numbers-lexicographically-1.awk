# syntax: GAWK -f SORT_NUMBERS_LEXICOGRAPHICALLY.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    prn(0)
    prn(1)
    prn(13)
    prn(9,10)
    prn(-11,+11)
    prn(-21)
    prn("",1)
    prn(+1,-1)
    exit(0)
}
function prn(n1,n2) {
    if (n1 <= 0 && n2 == "") {
      n2 = 1
    }
    if (n2 == "") {
      n2 = n1
      n1 = 1
    }
    printf("%d to %d: %s\n",n1,n2,snl(n1,n2))
}
function snl(start,stop,  arr,i,str) {
    if (start == "") {
      return("error: start=blank")
    }
    if (start > stop) {
      return("error: start>stop")
    }
    for (i=start; i<=stop; i++) {
      arr[i]
    }
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 2
    for (i in arr) {
      str = sprintf("%s%s ",str,i)
    }
    sub(/ $/,"",str)
    return(str)
}
