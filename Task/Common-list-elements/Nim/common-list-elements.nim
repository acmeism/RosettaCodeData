import algorithm, sequtils

proc commonElements(list: openArray[seq[int]]): seq[int] =
  var list = sortedByIt(list, it.len)   # Start with the shortest array.
  for val in list[0].deduplicate():     # Check values only once.
    block checkVal:
      for i in 1..list.high:
        if val notin list[i]:
          break checkVal
      result.add val

echo commonElements([@[2,5,1,3,8,9,4,6], @[3,5,6,2,9,8,4], @[1,3,7,6,9]])
