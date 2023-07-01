# syntax: GAWK -f ORDER_TWO_NUMERICAL_LISTS.AWK
BEGIN {
    split("1,2,1,5,2",list1,",")
    split("1,2,1,5,2,2",list2,",")
    split("1,2,3,4,5",list3,",")
    split("1,2,3,4,5",list4,",")
    x = compare_array(list1,list2) ? "<" : ">=" ; printf("list1%slist2\n",x)
    x = compare_array(list2,list3) ? "<" : ">=" ; printf("list2%slist3\n",x)
    x = compare_array(list3,list4) ? "<" : ">=" ; printf("list3%slist4\n",x)
    exit(0)
}
function compare_array(arr1,arr2,  ans,i) {
    ans = 0
    for (i=1; i<=length(arr1); i++) {
      if (arr1[i] != arr2[i]) {
        ans = 1
        break
      }
    }
    if (length(arr1) != length(arr2)) {
      ans = 1
    }
    return(ans)
}
