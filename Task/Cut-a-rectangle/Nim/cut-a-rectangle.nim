import strformat

var
  w, h: int
  grid: seq[byte]
  next: array[4, int]
  count: int

const Dirs = [[0, -1], [-1, 0], [0, 1], [1, 0]]

template odd(n: int): bool = (n and 1) != 0

#------------------------------------------------------------------------------

proc walk(y, x: int) =

  if y == 0 or y == h or x == 0 or x == w:
    inc count, 2
    return

  let t = y * (w + 1) + x
  inc grid[t]
  inc grid[grid.high - t]

  for i, dir in Dirs:
    if grid[t + next[i]] == 0:
      walk(y + dir[0], x + dir[1])

  dec grid[t]
  dec grid[grid.high - t]

#------------------------------------------------------------------------------

proc solve(y, x: int; recursive: bool): int =

  h = y
  w = x
  if odd(h): swap w, h

  if odd(h): return 0
  if w == 1: return 1
  if w == 2: return h
  if h == 2: return w

  let cy = h div 2
  let cx = w div 2

  grid = newSeq[byte]((w + 1) * (h + 1))

  next[0] = -1
  next[1] = -w - 1
  next[2] = 1
  next[3] = w + 1

  if recursive: count = 0

  for x in (cx + 1)..<w:
    let t = cy * (w + 1) + x
    grid[t] = 1
    grid[grid.high - t] = 1
    walk(cy - 1, x)
  inc count

  if h == w:
    count *= 2
  elif not odd(w) and recursive:
    discard solve(w, h, false)

  result = count

#——————————————————————————————————————————————————————————————————————————————

for y in 1..10:
  for x in 1..y:
    if not odd(x) or not odd(y):
      echo &"{y:2d} x {x:2d}: {solve(y, x, true)}"
