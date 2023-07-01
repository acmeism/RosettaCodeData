# syntax: GAWK -f COMPARE_A_LIST_OF_STRINGS.AWK
BEGIN {
    main("AA,BB,CC")
    main("AA,AA,AA")
    main("AA,CC,BB")
    main("AA,ACB,BB,CC")
    main("single_element")
    exit(0)
}
function main(list,  arr,i,n,test1,test2) {
    test1 = 1 # elements are identical
    test2 = 1 # elements are in ascending order
    n = split(list,arr,",")
    printf("\nlist:")
    for (i=1; i<=n; i++) {
      printf(" %s",arr[i])
      if (i > 1) {
        if (arr[i-1] != arr[i]) {
          test1 = 0 # elements are not identical
        }
        if (arr[i-1] >= arr[i]) {
          test2 = 0 # elements are not in ascending order
        }
      }
    }
    printf("\n%d\n%d\n",test1,test2)
}
