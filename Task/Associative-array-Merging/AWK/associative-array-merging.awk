# syntax: GAWK -f ASSOCIATIVE_ARRAY_MERGING.AWK
#
# sorting:
#   PROCINFO["sorted_in"] is used by GAWK
#   SORTTYPE is used by Thompson Automation's TAWK
#
BEGIN {
    PROCINFO["sorted_in"] = "@ind_str_asc" ; SORTTYPE = 1
    arr1["name"] = "Rocket Skates"
    arr1["price"] = "12.75"
    arr1["color"] = "yellow"
    show_array(arr1,"base")
    arr2["price"] = "15.25"
    arr2["color"] = "red"
    arr2["year"] = "1974"
    show_array(arr2,"update")
    for (i in arr1) { arr3[i] = arr1[i] }
    for (i in arr2) { arr3[i] = arr2[i] }
    show_array(arr3,"merged")
    exit(0)
}
function show_array(arr,desc,  i) {
    printf("\n%s array\n",desc)
    for (i in arr) {
      printf("%-5s : %s\n",i,arr[i])
    }
}
