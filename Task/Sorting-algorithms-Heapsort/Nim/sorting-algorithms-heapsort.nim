proc siftDown[T](a: var openarray[T]; start, ending: int) =
  var root = start
  while root * 2 + 1 < ending:
    var child = 2 * root + 1
    if child + 1 < ending and a[child] < a[child+1]:
      inc child
    if a[root] < a[child]:
      swap a[child], a[root]
      root = child
    else:
      return

proc heapSort[T](a: var openarray[T]) =
  let count = a.len
  for start in countdown((count - 2) div 2, 0):
    siftDown(a, start, count)
  for ending in countdown(count - 1, 1):
    swap a[ending], a[0]
    siftDown(a, 0, ending)

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
heapSort a
echo a
