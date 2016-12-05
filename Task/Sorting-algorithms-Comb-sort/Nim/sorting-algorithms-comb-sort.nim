proc combSort[T](a: var openarray[T]) =
  var gap = a.len
  var swapped = true
  while gap > 1 or swapped:
    gap = gap * 10 div 13
    if gap == 9 or gap == 10: gap = 11
    if gap < 1: gap = 1
    swapped = false
    var i = 0
    for j in gap .. <a.len:
      if a[i] > a[j]:
        swap a[i], a[j]
        swapped = true
      inc i

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
combSort a
echo a
