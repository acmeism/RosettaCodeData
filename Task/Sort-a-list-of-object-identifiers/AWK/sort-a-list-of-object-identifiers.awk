# syntax: GAWK -f SORT_A_LIST_OF_OBJECT_IDENTIFIERS.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    width = 10
    oid_arr[++n] = "1.3.6.1.4.1.11.2.17.19.3.4.0.10"
    oid_arr[++n] = "1.3.6.1.4.1.11.2.17.5.2.0.79"
    oid_arr[++n] = "1.3.6.1.4.1.11.2.17.19.3.4.0.4"
    oid_arr[++n] = "1.3.6.1.4.1.11150.3.4.0.1"
    oid_arr[++n] = "1.3.6.1.4.1.11.2.17.19.3.4.0.1"
    oid_arr[++n] = "1.3.6.1.4.1.11150.3.4.0"
#   oid_arr[++n] = "1.11111111111.1" # un-comment to test error
    for (i=1; i<=n; i++) {
      str = ""
      for (j=1; j<=split(oid_arr[i],arr2,"."); j++) {
        str = sprintf("%s%*s.",str,width,arr2[j])
        if ((leng = length(arr2[j])) > width) {
          printf("error: increase sort key width from %d to %d for entry %s\n",width,leng,oid_arr[i])
          exit(1)
        }
      }
      arr3[str] = ""
    }
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    for (i in arr3) {
      str = i
      gsub(/ /,"",str)
      sub(/\.$/,"",str)
      printf("%s\n",str)
    }
    exit(0)
}
