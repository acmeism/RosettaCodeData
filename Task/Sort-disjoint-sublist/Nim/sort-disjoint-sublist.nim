import algorithm

proc sortDisjoinSublist[T](data: var seq[T], indices: seq[int]) =
  var indices = indices
  sort indices, cmp[T]

  var values: seq[T] = @[]
  for i in indices: values.add data[i]
  sort values, cmp[T]

  for j, i in indices: data[i] = values[j]

var d = @[7, 6, 5, 4, 3, 2, 1, 0]
sortDisjoinSublist(d, @[6, 1, 7])
echo d
