# syntax: GAWK -f TWO_SUM.AWK
BEGIN {
    numbers = "0,2,11,19,90"
    print(two_sum(numbers,21))
    print(two_sum(numbers,25))
    exit(0)
}
function two_sum(numbers,sum,  arr,i,j,s) {
    i = 1
    j = split(numbers,arr,",")
    while (i < j) {
      s = arr[i] + arr[j]
      if (s == sum) {
        return(sprintf("[%d,%d]",i,j))
      }
      else if (s < sum) {
        i++
      }
      else {
        j--
      }
    }
    return("[]")
}
