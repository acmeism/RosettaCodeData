# syntax: GAWK -f UNIQUE_CHARACTERS_IN_EACH_STRING.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    n = split("1a3c52debeffd,2b6178c97a938stf,3ycxdb1fgxa2yz",arr1,",")
    for (i=1; i<=n; i++) {
      str = arr1[i]
      printf("%s\n",str)
      total_c += leng = length(str)
      for (j=1; j<=leng; j++) {
        arr2[substr(str,j,1)][i]++
      }
    }
    for (c in arr2) {
      flag = 0
      for (i=1; i<=n; i++) {
        if (arr2[c][i] != 1) {
          flag = 1
        }
      }
      if (flag == 0) {
        rec = sprintf("%s%s",rec,c)
      }
    }
    printf("%d strings, %d characters, %d different, %d unique: %s\n",n,total_c,length(arr2),length(rec),rec)
    exit(0)
}
