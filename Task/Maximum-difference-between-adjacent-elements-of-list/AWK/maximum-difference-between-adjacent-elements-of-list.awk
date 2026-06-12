# syntax: GAWK -f MAXIMUM_DIFFERENCE_BETWEEN_ADJACENT_ELEMENTS_OF_LIST.AWK
BEGIN {
    list = "1,8,2,-3,0,1,1,-2.3,0,5.5,8,6,2,9,11,10,3"
    n = split(list,arr,",")
    for (i=1; i<n; i++) {
      a = arr[i]
      b = arr[i+1]
      if (abs(a-b) == highest) {
        sets = sprintf("%s%s,%s  ",sets,a,b)
      }
      else if (abs(a-b) > highest) {
        highest = abs(a-b)
        sets = sprintf("%s,%s  ",a,b)
      }
    }
    printf("%s: %s\n",highest,sets)
    exit(0)
}
function abs(x) { if (x >= 0) { return x } else { return -x } }
