proc mergeList[T](a, b: var seq[T]): seq[T] =
  result = @[]
  while a.len > 0 and b.len > 0:
    if a[0] < b[0]:
      result.add a[0]
      a.delete 0
    else:
      result.add b[0]
      b.delete 0
  result.add a
  result.add b

proc strand[T](a: var seq[T]): seq[T] =
  var i = 0
  result = @[a[0]]
  a.delete 0
  while i < a.len:
    if a[i] > result[result.high]:
      result.add a[i]
      a.delete i
    else:
      inc i

proc strandSort[T](a: seq[T]): seq[T] =
  var a = a
  result = a.strand
  while a.len > 0:
    var s = a.strand
    result = mergeList(result, s)

var a = @[1, 6, 3, 2, 1, 7, 5, 3]
echo a.strandSort
