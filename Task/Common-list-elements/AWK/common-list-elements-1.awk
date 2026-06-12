# syntax: GAWK -f COMMON_LIST_ELEMENTS.AWK
BEGIN {
    PROCINFO["sorted_in"] = "@ind_num_asc"
    nums = "[2,5,1,3,8,9,4,6],[3,5,6,2,9,8,4],[1,3,7,6,9]"
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
      if (arr3[j] == n) {
        printf("%s ",j)
      }
    }
    printf("\n")
    exit(0)
}
