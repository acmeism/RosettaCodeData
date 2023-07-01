proc merge[T](a, b: var openarray[T]; left, middle, right: int) =
  let
    leftLen = middle - left
    rightLen = right - middle
  var
    l = 0
    r = leftLen

  for i in left ..< middle:
    b[l] = a[i]
    inc l
  for i in middle ..< right:
    b[r] = a[i]
    inc r

  l = 0
  r = leftLen
  var i = left

  while l < leftLen and r < leftLen + rightLen:
    if b[l] < b[r]:
      a[i] = b[l]
      inc l
    else:
      a[i] = b[r]
      inc r
    inc i

  while l < leftLen:
    a[i] = b[l]
    inc l
    inc i
  while r < leftLen + rightLen:
    a[i] = b[r]
    inc r
    inc i

proc mergeSort[T](a, b: var openarray[T]; left, right: int) =
  if right - left <= 1: return

  let middle = (left + right) div 2
  mergeSort(a, b, left, middle)
  mergeSort(a, b, middle, right)
  merge(a, b, left, middle, right)

proc mergeSort[T](a: var openarray[T]) =
  var b = newSeq[T](a.len)
  mergeSort(a, b, 0, a.len)

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
mergeSort a
echo a
