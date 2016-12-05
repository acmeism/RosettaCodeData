import strutils

type Pos = tuple[x, y: int]

proc newSeqWith[T](len: int, init: T): seq[T] =
  result = newSeq[T] len
  for i in 0 .. <len:
    result[i] = init

proc `^`*(base: int, exp: int): int =
  var (base, exp) = (base, exp)
  result = 1

  while exp != 0:
    if (exp and 1) != 0:
      result *= base
    exp = exp shr 1
    base *= base

proc `$`(m: seq[seq[int]]): string =
  result = ""
  for r in m:
    for c in r:
      result.add align($c, 2) & " "
    result.add "\n"

proc spiral(n): auto =
  result = newSeqWith(n, newSeqWith[int](n, -1))
  var dx = 1
  var dy, x, y = 0
  for i in 0 .. <(n^2):
    result[y][x] = i
    let (nx, ny) = (x+dx, y+dy)
    if nx in 0 .. <n and ny in 0 .. <n and result[ny][nx] == -1:
      x = nx
      y = ny
    else:
      swap dx, dy
      dx = -dx
      x = x + dx
      y = y + dy

echo spiral(5)
