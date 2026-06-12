# syntax: GAWK -f UNIQUE_CHARACTERS.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    n = split("133252abcdeeffd,a6789798st,yxcdfgxcyz",arr1,",")
    for (i=1; i<=n; i++) {
      str = arr1[i]
      printf("%s\n",str)
      total_c += leng = length(str)
      for (j=1; j<=leng; j++) {
        arr2[substr(str,j,1)]++
      }
    }
    for (c in arr2) {
      if (arr2[c] == 1) {
        rec = sprintf("%s%s",rec,c)
      }
    }
    printf("%d strings, %d characters, %d different, %d unique: %s\n",n,total_c,length(arr2),length(rec),rec)
    exit(0)
}
