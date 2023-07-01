import random, sequtils, strformat

const
  N = 15
  T = 5
  P = 0.5
  NotClustered = 1
  Cell2Char = " #abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  NRange = [4, 64, 256, 1024, 4096]

type Grid = seq[seq[int]]


proc newGrid(n: Positive; p: float): Grid =
  result = newSeqWith(n, newSeq[int](n))
  for row in result.mitems:
    for cell in row.mitems:
      if rand(1.0) < p: cell = 1


func walkMaze(grid: var Grid; m, n, idx: int) =
  grid[n][m] = idx
  if n < grid.high and grid[n + 1][m] == NotClustered:
    grid.walkMaze(m, n + 1, idx)
  if m < grid[0].high and grid[n][m + 1] == NotClustered:
    grid.walkMaze(m + 1, n, idx)
  if m > 0 and grid[n][m - 1] == NotClustered:
    grid.walkMaze(m - 1, n, idx)
  if n > 0 and grid[n - 1][m] == NotClustered:
    grid.walkMaze(m, n - 1, idx)


func clusterCount(grid: var Grid): int =
  var walkIndex = 1
  for n in 0..grid.high:
    for m in 0..grid[0].high:
      if grid[n][m] == NotClustered:
        inc walkIndex
        grid.walkMaze(m, n, walkIndex)
  result = walkIndex - 1


proc clusterDensity(n: int; p: float): float =
  var grid = newGrid(n, p)
  result = grid.clusterCount() / (n * n)


proc print(grid: Grid) =
  for n, row in grid:
    stdout.write n mod 10, ") "
    for cell in row:
      stdout.write ' ', Cell2Char[cell]
    stdout.write '\n'


when isMainModule:

  randomize()

  var grid = newGrid(N, 0.5)
  echo &"Found {grid.clusterCount()} clusters in this {N} by {N} grid\n"
  grid.print()
  echo ""

  for n in NRange:
    var sum = 0.0
    for _ in 1..T:
      sum += clusterDensity(n, P)
    let sim = sum / T
    echo &"t = {T}  p = {P:4.2f}  n = {n:4}  sim = {sim:7.5f}"
