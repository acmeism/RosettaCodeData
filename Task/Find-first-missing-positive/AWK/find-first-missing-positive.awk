# syntax: GAWK -f FIND_FIRST_MISSING_POSITIVE.AWK
BEGIN {
    PROCINFO["sorted_in"] = "@ind_num_asc"
    nums = "[1,2,0],[3,4,-1,1],[7,8,9,11,12]"
    printf("%s : ",nums)
    n = split(nums,arr1,"],?") - 1
    for (i=1; i<=n; i++) {
      gsub(/[\[\]]/,"",arr1[i])
      split(arr1[i],arr2,",")
      for (j in arr2) {
        arr3[arr2[j]]++
      }
      for (j in arr3) {
        if (j <= 0) {
          continue
        }
        if (!(1 in arr3)) {
          ans = 1
          break
        }
        if (!(j+1 in arr3)) {
          ans = j + 1
          break
        }
      }
      printf("%d ",ans)
      delete arr3
    }
    printf("\n")
    exit(0)
}
