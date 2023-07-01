import random, sequtils, strutils

const

  F = @[[1, -1, 1, 0, 1, 1, 2, 1], [0, 1, 1, -1, 1, 0, 2, 0],
        [1, 0, 1, 1, 1, 2, 2, 1], [1, 0, 1, 1, 2, -1, 2, 0],
        [1, -2, 1, -1, 1, 0, 2, -1], [0, 1, 1, 1, 1, 2, 2, 1],
        [1, -1, 1, 0, 1, 1, 2, -1], [1, -1, 1, 0, 2, 0, 2, 1]]

  I = @[[0, 1, 0, 2, 0, 3, 0, 4], [1, 0, 2, 0, 3, 0, 4, 0]]

  L = @[[1, 0, 1, 1, 1, 2, 1, 3], [1, 0, 2, 0, 3, -1, 3, 0],
        [0, 1, 0, 2, 0, 3, 1, 3], [0, 1, 1, 0, 2, 0, 3, 0],
        [0, 1, 1, 1, 2, 1, 3, 1], [0, 1, 0, 2, 0, 3, 1, 0],
        [1, 0, 2, 0, 3, 0, 3, 1], [1, -3, 1, -2, 1, -1, 1, 0]]

  N = @[[0, 1, 1, -2, 1, -1, 1, 0], [1, 0, 1, 1, 2, 1, 3, 1],
        [0, 1, 0, 2, 1, -1, 1, 0], [1, 0, 2, 0, 2, 1, 3, 1],
        [0, 1, 1, 1, 1, 2, 1, 3], [1, 0, 2, -1, 2, 0, 3, -1],
        [0, 1, 0, 2, 1, 2, 1, 3], [1, -1, 1, 0, 2, -1, 3, -1]]

  P = @[[0, 1, 1, 0, 1, 1, 2, 1], [0, 1, 0, 2, 1, 0, 1, 1],
        [1, 0, 1, 1, 2, 0, 2, 1], [0, 1, 1, -1, 1, 0, 1, 1],
        [0, 1, 1, 0, 1, 1, 1, 2], [1, -1, 1, 0, 2, -1, 2, 0],
        [0, 1, 0, 2, 1, 1, 1, 2], [0, 1, 1, 0, 1, 1, 2, 0]]

  T = @[[0, 1, 0, 2, 1, 1, 2, 1], [1, -2, 1, -1, 1, 0, 2, 0],
        [1, 0, 2, -1, 2, 0, 2, 1], [1, 0, 1, 1, 1, 2, 2, 0]]


  U = @[[0, 1, 0, 2, 1, 0, 1, 2], [0, 1, 1, 1, 2, 0, 2, 1],
        [0, 2, 1, 0, 1, 1, 1, 2], [0, 1, 1, 0, 2, 0, 2, 1]]

  V = @[[1, 0, 2, 0, 2, 1, 2, 2], [0, 1, 0, 2, 1, 0, 2, 0],
        [1, 0, 2, -2, 2, -1, 2, 0], [0, 1, 0, 2, 1, 2, 2, 2]]

  W = @[[1, 0, 1, 1, 2, 1, 2, 2], [1, -1, 1, 0, 2, -2, 2, -1],
        [0, 1, 1, 1, 1, 2, 2, 2], [0, 1, 1, -1, 1, 0, 2, -1]]

  X = @[[1, -1, 1, 0, 1, 1, 2, 0]]

  Y = @[[1, -2, 1, -1, 1, 0, 1, 1], [1, -1, 1, 0, 2, 0, 3, 0],
        [0, 1, 0, 2, 0, 3, 1, 1], [1, 0, 2, 0, 2, 1, 3, 0],
        [0, 1, 0, 2, 0, 3, 1, 2], [1, 0, 1, 1, 2, 0, 3, 0],
        [1, -1, 1, 0, 1, 1, 1, 2], [1, 0, 2, -1, 2, 0, 3, 0]]

  Z = @[[0, 1, 1, 0, 2, -1, 2, 0], [1, 0, 1, 1, 1, 2, 2, 2],
        [0, 1, 1, 1, 2, 1, 2, 2], [1, -2, 1, -1, 1, 0, 2, -2]]

  Shapes = [F, I, L, N, P, T, U, V, W, X, Y, Z]
  Symbols = @"FILNPTUVWXYZ-"

  NRows = 8
  NCols = 8
  Blank = Shapes.len


type Tiling = object
  shapes: array[Shapes.len, seq[array[8, int]]]   # Shuffled shapes.
  symbols: array[Symbols.len, char]               # Associated symbols.
  grid: array[NRows, array[NCols, int]]
  placed: array[Shapes.len, bool]


proc initTiling(): Tiling =

  # Build list of shapes and symbols.
  var indexes = toSeq(0..11)
  indexes.shuffle()
  for i, index in indexes:
    result.shapes[i] = Shapes[index]
    result.symbols[i] = Symbols[index]
  result.symbols[^1] = Symbols[^1]

  # Fill grid.
  for r in result.grid.mitems:
    for c in r.mitems:
      c = -1
  for i in 0..3:
    while true:
      let randRow = rand(NRows - 1)
      let randCol = rand(NCols - 1)
      if result.grid[randRow][randCol] != Blank:
        result.grid[randRow][randCol] = Blank
        break


func tryPlaceOrientation(t: var Tiling; o: openArray[int]; r, c, shapeIndex: int): bool =
  for i in countup(0, o.len - 2, 2):
    let x = c + o[i + 1]
    let y = r + o[i]
    if x notin 0..<NCols or y notin 0..<NRows or t.grid[y][x] != - 1: return false
  t.grid[r][c] = shapeIndex
  for i in countup(0, o.len - 2, 2): t.grid[r + o[i]][c + o[i + 1]] = shapeIndex
  result = true


func removeOrientation(t: var Tiling; o: openArray[int]; r, c: int) =
  t.grid[r][c] = -1
  for i in countup(0, o.len - 2, 2): t.grid[r + o[i]][c + o[i + 1]] = -1


func solve(t: var Tiling; pos, numPlaced: int): bool =
  if numPlaced == t.shapes.len: return true
  let row = pos div NCols
  let col = pos mod NCols
  if t.grid[row][col] != -1: return t.solve(pos + 1, numPlaced)

  for i in 0..<t.shapes.len:
    if not t.placed[i]:
      for orientation in t.shapes[i]:
        if not t.tryPlaceOrientation(orientation, row, col, i): continue
        t.placed[i] = true
        if t.solve(pos + 1, numPlaced + 1): return true
        t.removeOrientation(orientation, row, col)
        t.placed[i] = false


proc printResult(t: Tiling) =
  for r in t.grid:
    echo r.mapIt(t.symbols[it]).join(" ")


when isMainModule:
  randomize()
  var tiling = initTiling()
  if tiling.solve(0, 0): tiling.printResult
  else: echo "No solution"
