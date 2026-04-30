# syntax: GAWK -f EGYPTIAN_DIVISION.AWK
# converted from FutureBasic
BEGIN {
    i = 1
    dividend = 580
    divisor = 34
    array[i,1] = 1
    array[i,2] = divisor
    while (array[i,2] < dividend) {
      i++
      array[i,1] = array[i-1,1] * 2
      array[i,2] = array[i-1,2] * 2
    }
    i--
    answer = array[i,1]
    accumulator = array[i,2]
    while (i > 1) {
      i--
      if (array[i,2] + accumulator <= dividend) {
        answer += array[i,1]
        accumulator += array[i,2]
      }
    }
    printf("%d / %d = %d remainder %d\n",dividend,divisor,answer,dividend-accumulator)
    exit(0)
}
