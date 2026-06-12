# syntax: GAWK -f LONGEST_COMMON_SUFFIX.AWK
BEGIN {
    arr1[++n1] = "AAbcd,Abcd,abcd,bcd"
    arr1[++n1] = "11Sunday,2Sunday"
    arr1[++n1] = "Sunday,Monday"
    arr1[++n1] = "Sunday,Monday,day"
    arr1[++n1] = "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday"
    arr1[++n1] = "crucifix,infix,prefix,suffix"
    arr1[++n1] = "identical,identical"
    arr1[++n1] = ","
    arr1[++n1] = "this,has,nothing,in,common"
    for (i=1; i<=n1; i++) {
      n2 = split(arr1[i],arr2,",")
      min_wid = 999
      for (j=1; j<=n2; j++) {
        leng = length(arr2[j])
        if (min_wid > leng) {
          min_wid = leng
          min_col = j
        }
      }
      cols = 0
      for (j=1; j<=min_wid; j++) {
        delete arr3
        for (k=1; k<n2; k++) {
          arr3[substr(arr2[k],length(arr2[k])+1-j)] = ""
          arr3[substr(arr2[k+1],length(arr2[k+1])+1-j)] = ""
        }
        if (length(arr3) == 1) {
          cols++
        }
      }
      printf("'%s' : '%s'\n",arr1[i],(cols == 0) ? "" : substr(arr2[min_col],length(arr2[min_col])+1-cols))
    }
    exit(0)
}
