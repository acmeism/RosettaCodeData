# syntax: GAWK -f SHIFT_LIST_ELEMENTS_TO_LEFT_BY_3.AWK
BEGIN {
    list = "1,2,3,4,5,6,7,8,9"
    printf("old: %s\n",list)
    printf("new: %s\n",shift_left(list,3))
    list = "a;b;c;d"
    printf("old: %s\n",list)
    printf("new: %s\n",shift_left(list,1,";"))
    exit(0)
}
function shift_left(str,n,sep,  i,left,right) {
    if (sep == "") {
      sep = ","
    }
    for (i=1; i<=n; i++) {
      left = substr(str,1,index(str,sep)-1)
      right = substr(str,index(str,sep)+1)
      str = right sep left
    }
    return(str)
}
