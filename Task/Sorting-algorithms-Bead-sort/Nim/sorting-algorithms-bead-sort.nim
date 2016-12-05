proc beadSort[T](a: var openarray[T]) =
  var max = low(T)
  var sum = 0

  for x in a:
    if x > max: max = x

  var beads = newSeq[int](max * a.len)

  for i in 0 .. < a.len:
    for j in 0 .. < a[i]:
      beads[i * max + j] = 1

  for j in 0 .. < max:
    sum = 0
    for i in 0 .. < a.len:
      sum += beads[i * max + j]
      beads[i * max + j] = 0

    for i in a.len - sum .. < a.len:
      beads[i * max + j] = 1

  for i in 0 .. < a.len:
    var j = 0
    while j < max and beads[i * max + j] > 0: inc j
    a[i] = j

var a = @[5, 3, 1, 7, 4, 1, 1, 20]
beadSort a
echo a
