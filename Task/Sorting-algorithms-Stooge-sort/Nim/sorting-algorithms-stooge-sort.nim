proc stoogeSort[T](a: var openarray[T], i, j: int) =
  if a[j] < a[i]: swap a[i], a[j]
  if j - i > 1:
    let t = (j - i + 1) div 3
    stoogeSort(a, i, j - t)
    stoogeSort(a, i + t, j)
    stoogeSort(a, i, j - t)

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
stoogeSort a, 0, a.high
echo a
