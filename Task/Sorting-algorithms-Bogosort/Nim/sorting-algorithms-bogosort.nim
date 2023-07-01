import random

randomize()

proc isSorted[T](s: openarray[T]): bool =
  var last = low(T)
  for c in s:
    if c < last:
      return false
    last = c
  return true

proc bogoSort[T](a: var openarray[T]) =
  while not isSorted a: shuffle a

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
bogoSort a
echo a
