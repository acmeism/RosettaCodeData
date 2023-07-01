iterator permutations[T](ys: openarray[T]): seq[T] =
  var
    d = 1
    c = newSeq[int](ys.len)
    xs = newSeq[T](ys.len)

  for i, y in ys: xs[i] = y
  yield xs

  block outter:
    while true:
      while d > 1:
        dec d
        c[d] = 0
      while c[d] >= d:
        inc d
        if d >= ys.len: break outter

      let i = if (d and 1) == 1: c[d] else: 0
      swap xs[i], xs[d]
      yield xs
      inc c[d]

proc isSorted[T](s: openarray[T]): bool =
  var last = low(T)
  for c in s:
    if c < last:
      return false
    last = c
  return true

proc permSort[T](a: openarray[T]): seq[T] =
  for p in a.permutations:
    if p.isSorted:
      return p

var a = @[4, 65, 2, -31, 0, 99, 2, 83, 782]
echo a.permSort
