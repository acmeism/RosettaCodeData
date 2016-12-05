# iterative Boothroyd method
iterator permutations[T](ys: openarray[T]): seq[T] =
  var
    d = 1
    c = newSeq[int](ys.len)
    xs = newSeq[T](ys.len)

  for i, y in ys: xs[i] = y
  yield xs

  block outer:
    while true:
      while d > 1:
        dec d
        c[d] = 0
      while c[d] >= d:
        inc d
        if d >= ys.len: break outer

      let i = if (d and 1) == 1: c[d] else: 0
      swap xs[i], xs[d]
      yield xs
      inc c[d]

var x = @[1,2,3]

for i in permutations(x):
  echo i
