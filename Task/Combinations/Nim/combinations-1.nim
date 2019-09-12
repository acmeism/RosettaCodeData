iterator comb(m, n): seq[int] =
  var c = newSeq[int](n)
  for i in 0 .. <n: c[i] = i

  block outer:
    while true:
      yield c

      var i = n-1
      inc c[i]
      if c[i] <= m - 1: continue

      while c[i] >= m - n + i:
        dec i
        if i < 0: break outer
      inc c[i]
      while i < n-1:
        c[i+1] = c[i] + 1
        inc i

for i in comb(5, 3): echo i
