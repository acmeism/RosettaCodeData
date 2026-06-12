import algorithm, sequtils

proc commonSortedList(list: openArray[seq[int]]): seq[int] =
  sorted(concat(list)).deduplicate(true)

echo commonSortedList([@[5,1,3,8,9,4,8,7], @[3,5,9,8,4], @[1,3,7,9]])
