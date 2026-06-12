# syntax: GAWK -f COLLECT_AND_SORT_SQUARE_NUMBERS_IN_ASCENDING_ORDER_FROM_THREE_LISTS.AWK
BEGIN {
    list[1] = "3,4,34,25,9,12,36,56,36"
    list[2] = "2,8,81,169,34,55,76,49,7"
    list[3] = "75,121,75,144,35,16,46,35"
    for (i=1; i<=length(list); i++) {
      n = split(list[i],list_arr,",")
      for (j=1; j<=n; j++) {
        if (is_square(list_arr[j])) {
          sq_arr[i,j] = list_arr[j]
        }
      }
    }
    PROCINFO["sorted_in"] = "@val_num_asc"
    for (i in sq_arr) {
      printf("%d ",sq_arr[i])
    }
    printf("\n")
    exit(0)
}
function is_square(n) {
    return (int(sqrt(n))^2 == n)
}
