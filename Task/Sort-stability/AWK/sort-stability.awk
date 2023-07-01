# syntax: GAWK -f SORT_STABILITY.AWK [-v width=x] -v field=x SORT_STABILITY.TXT
#
# sort by country: GAWK -f SORT_STABILITY.AWK -v field=1 SORT_STABILITY.TXT
# sort by city:    GAWK -f SORT_STABILITY.AWK -v field=2 SORT_STABILITY.TXT
#
# awk sort is not stable. Stability may be achieved by appending the
# record number, I.E. NR, to each key.
#
BEGIN {
    FIELDWIDTHS = "4 20" # 2 fields: country city
    PROCINFO["sorted_in"] = "@ind_str_asc"
    if (width == "") {
      width = 6
    }
}
{ arr[$field sprintf("%0*d",width,NR)] = $0 }
END {
    if (length(NR) > width) {
      printf("error: sort may still be unstable; change width to %d\n",length(NR))
      exit(1)
    }
    printf("after sorting on field %d:\n",field)
    for (i in arr) {
      printf("%s\n",arr[i])
    }
    exit(0)
}
