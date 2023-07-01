template isEven(n: int64): bool = (n and 1) == 0

func gcd_binary*(u, v: int64): int64 =

  var u = abs(u)
  var v = abs(v)
  if u < v: swap u, v

  if v == 0: return u

  var k = 1
  while u.isEven and v.isEven:
    u = u shr 1
    v = v shr 1
    k = k shl 1
  var t = if u.isEven: u else: -v
  while t != 0:
    while t.isEven: t = ashr(t, 1)
    if t > 0: u = t
    else: v = -t
    t = u - v
  result = u * k

when isMainModule:
  import strformat
  let (x, y) = (49865, 69811)
  echo &"gcd({x}, {y}) = {gcd_binary(49865, 69811)}"
