import math, strformat

const MaxIter = 151


func minkowski(x: float): float =

  if x notin 0.0..1.0:
    return floor(x) + minkowski(x - floor(x))

  var
    p = x.uint64
    r = p + 1
    q, s = 1u64
    d = 1.0
    y = p.float

  while true:
    d /= 2
    if y + d == y: break
    let m = p + r
    if m < 0 or p < 0: break
    let n = q + s
    if n < 0: break
    if x < m.float / n.float:
      r = m
      s = n
    else:
      y += d
      p = m
      q = n

  result = y + d


func minkowskiInv(x: float): float =

  if x notin 0.0..1.0:
    return floor(x) + minkowskiInv(x - floor(x))
  if x == 1 or x == 0:
    return x

  var
    contFrac: seq[uint32]
    curr = 0u32
    count = 1u32
    i = 0
    x = x

  while true:
    x *= 2
    if curr == 0:
      if x < 1:
        inc count
      else:
        inc i
        contFrac.setLen(i + 1)
        contFrac[i - 1] = count
        count = 1
        curr = 1
        x -= 1
    else:
      if x > 1:
        inc count
        x -= 1
      else:
        inc i
        contFrac.setLen(i + 1)
        contFrac[i - 1] = count
        count = 1
        curr = 0
    if x == floor(x):
      contFrac[i] = count
      break
    if i == MaxIter:
      break

  var ret = 1 / contFrac[i].float
  for j in countdown(i - 1, 0):
    ret = contFrac[j].float + 1 / ret
  result = 1 / ret


echo &"{minkowski(0.5*(1+sqrt(5.0))):19.16f}, {5/3:19.16f}"
echo &"{minkowskiInv(-5/9):19.16f}, {(sqrt(13.0)-7)/6:19.16f}"
echo &"{minkowski(minkowskiInv(0.718281828)):19.16f}, " &
     &"{minkowskiInv(minkowski(0.1213141516171819)):19.16f}"
