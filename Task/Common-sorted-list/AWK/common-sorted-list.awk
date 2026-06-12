# syntax: GAWK -f COMMON_SORTED_LIST.AWK
BEGIN {
    PROCINFO["sorted_in"] = "@ind_num_asc"
    nums = "[5,1,3,8,9,4,8,7],[3,5,9,8,4],[1,3,7,9]"
    printf("%s : ",nums)
    n = split(nums,arr1,"],?") - 1
    for (i=1; i<=n; i++) {
      gsub(/[\[\]]/,"",arr1[i])
      split(arr1[i],arr2,",")
      for (j in arr2) {
        arr3[arr2[j]]++
      }
    }
    for (j in arr3) {
      printf("%s ",j)
    }
    printf("\n")
    exit(0)
}
