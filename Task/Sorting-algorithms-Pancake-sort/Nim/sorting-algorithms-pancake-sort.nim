import algorithm

proc pancakeSort[T](list: var openarray[T]) =
  var length = list.len
  if length < 2: return

  var moves = 0

  for i in countdown(length, 2):
    var maxNumPos = 0
    for a in 0 .. <i:
      if list[a] > list[maxNumPos]:
        maxNumPos = a

    if maxNumPos == i - 1: continue

    if maxNumPos > 0:
      inc moves
      reverse(list, 0, maxNumPos)

    inc moves
    reverse(list, 0, i - 1)

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
pancakeSort a
echo a
