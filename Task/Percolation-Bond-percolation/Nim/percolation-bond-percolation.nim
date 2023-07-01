import random, sequtils, strformat, tables

type

  Cell = object
    full: bool
    right, down: bool     # True if open to the right (x+1) or down (y+1).

  Grid = seq[seq[Cell]]   # Row first, i.e. [y][x].


proc newGrid(p: float; xsize, ysize: Positive): Grid =

  result = newSeqWith(ysize, newSeq[Cell](xsize))
  for row in result.mitems:
    for x in 0..(xsize - 2):
      if rand(1.0) > p: row[x].right = true
      if rand(1.0) > p: row[x].down = true
    if rand(1.0) > p: row[xsize - 1].down = true


const
  Full = {false: "  ", true: "()"}.toTable
  HOpen = {false: "--", true: "  "}.toTable
  VOpen = {false: "|", true: " "}.toTable

proc `$`(grid: Grid): string =

  # Preallocate result to avoid multiple reallocations.
  result = newStringOfCap((grid.len + 1) * grid[0].len * 7)

  for _ in 0..grid[0].high:
    result.add '+'
    result.add HOpen[false]
  result.add "+\n"

  for row in grid:
    result.add VOpen[false]
    for cell in row:
      result.add Full[cell.full]
      result.add VOpen[cell.right]
    result.add '\n'
    for cell in row:
      result.add '+'
      result.add HOpen[cell.down]
    result.add "+\n"

  for cell in grid[^1]:
    result.add ' '
    result.add Full[cell.down and cell.full]


proc fill(grid: var Grid; x, y: Natural): bool =

  if y >= grid.len: return true     # Out the bottom.
  if grid[y][x].full: return false  # Already filled.
  grid[y][x].full = true

  if grid[y][x].down and grid.fill(x, y + 1): return true
  if grid[y][x].right and grid.fill(x + 1, y): return true
  if x > 0 and grid[y][x - 1].right and grid.fill(x - 1, y): return true
  if y > 0 and grid[y - 1][x].down and grid.fill(x, y - 1): return true


proc percolate(grid: var Grid): bool =
  for x in 0..grid[0].high:
    if grid.fill(x, 0): return true


const
  M = 10
  N = 10
  T = 1000
  MinP = 0.1
  MaxP = 0.99
  ΔP = 0.1

# Purposely don't seed for a repeatable example grid.
var grid = newGrid(0.4, M, N)
discard grid.percolate()
echo grid
echo ""

randomize()
var p = MinP
while p < MaxP:
  var count = 0
  for _ in 1..T:
    var grid = newGrid(p, M, N)
    if grid.percolate(): inc count
  echo &"p = {p:.2f}: {count / T:.3f}"
  p += ΔP
