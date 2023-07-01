proc selectionSort[T](a: var openarray[T]) =
  let n = a.len
  for i in 0 ..< n:
    var m = i
    for j in i ..< n:
      if a[j] < a[m]:
        m = j
    swap a[i], a[m]

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
selectionSort a
echo a
