proc countingSort[T](a: var openarray[T]; min, max: int) =
  let range = max - min + 1
  var count = newSeq[T](range)
  var z = 0

  for i in 0 ..< a.len: inc count[a[i] - min]

  for i in min .. max:
    for j in 0 ..< count[i - min]:
      a[z] = i
      inc z

var a = @[5, 3, 1, 7, 4, 1, 1, 20]
countingSort(a, 1, 20)
echo a
