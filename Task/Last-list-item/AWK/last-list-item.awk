# syntax: GAWK -f LAST_LIST_ITEM.AWK
BEGIN {
    split("6,81,243,14,25,49,123,69,11",arr1,",")
    PROCINFO["sorted_in"] = "@val_num_asc"
    while (length(arr1) > 1) {
      for (i in arr1) { printf("%s ",arr1[i]) } # show sorted list
      j = 0
      delete arr2
      for (i in arr1) { arr2[++j] = arr1[i] } # copy arr1 into arr2
      sum = arr2[1] + arr2[2]
      printf(": %s+%s=%s\n",arr2[1],arr2[2],sum)
      delete arr2[2]
      arr2[1] = sum
      delete arr1
      for (i in arr2) { arr1[i] = arr2[i] } # copy arr2 into arr1
    }
    printf("sum=%d\n",sum)
    exit(0)
}
