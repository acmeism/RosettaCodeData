import sequtils, strutils

proc `$`(m: seq[seq[int]]): string =
  for r in m:
    let lg = result.len
    for c in r:
      result.addSep(" ", lg)
      result.add align($c, 2)
    result.add '\n'

proc spiral(n: Positive): seq[seq[int]] =
  result = newSeqWith(n, repeat(-1, n))
  var dx = 1
  var dy, x, y = 0
  for i in 0 ..< (n * n):
    result[y][x] = i
    let (nx, ny) = (x+dx, y+dy)
    if nx in 0 ..< n and ny in 0 ..< n and result[ny][nx] == -1:
      x = nx
      y = ny
    else:
      swap dx, dy
      dx = -dx
      x += dx
      y += dy

echo spiral(5)
