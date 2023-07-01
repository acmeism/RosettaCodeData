import random, sequtils, strformat, strutils

type Grid = seq[string]   # Row first, i.e. [y][x].

const
  Full = '.'
  Used = '#'
  Empty = ' '


proc newGrid(p: float; xsize, ysize: Positive): Grid =

  result = newSeqWith(ysize, newString(xsize))
  for row in result.mitems:
    for cell in row.mitems:
      cell = if rand(1.0) < p: Full else: Empty


proc `$`(grid: Grid): string =

  # Preallocate result to avoid multiple reallocations.
  result = newStringOfCap((grid.len + 2) * (grid[0].len + 3))

  result.add '+'
  result.add repeat('-', grid[0].len)
  result.add "+\n"

  for row in grid:
    result.add '|'
    result.add row
    result.add "|\n"

  result.add '+'
  for cell in grid[^1]:
    result.add if cell == Used: Used else: '-'
  result.add '+'


proc use(grid: var Grid; x, y: int): bool =
  if y < 0 or x < 0 or x >= grid[0].len or grid[y][x] != Full:
    return false    # Off the edges, empty, or used.
  grid[y][x] = Used
  if y == grid.high: return true    # On the bottom.

  # Try down, right, left, up in that order.
  result = grid.use(x, y + 1) or grid.use(x + 1, y) or
           grid.use(x - 1, y) or grid.use(x, y - 1)


proc percolate(grid: var Grid): bool =
  for x in 0..grid[0].high:
    if grid.use(x, 0): return true


const
  M = 15
  N = 15

  T = 1000
  MinP = 0.0
  MaxP = 1.0
  ΔP = 0.1


randomize()
var grid = newGrid(0.5, M, N)
discard grid.percolate()
echo grid
echo ""

var p = MinP
while p < MaxP:
  var count = 0
  for _ in 1..T:
    var grid = newGrid(p, M, N)
    if grid.percolate(): inc count
  echo &"p = {p:.2f}: {count / T:.4f}"
  p += ΔP
