# iterative Boothroyd method
iterator permutations*[T](ys: openarray[T]): tuple[perm: seq[T], sign: int] =
  var
    d = 1
    c = newSeq[int](ys.len)
    xs = newSeq[T](ys.len)
    sign = 1

  for i, y in ys: xs[i] = y
  yield (xs, sign)

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
      sign *= -1
      yield (xs, sign)
      inc c[d]

when isMainModule:
  for i in permutations([0,1,2]):
    echo i

  echo ""

  for i in permutations([0,1,2,3]):
    echo i
