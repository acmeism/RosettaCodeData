import algorithm, sequtils, strformat

const Moves = [(-3, 0), (0,  3), ( 3, 0), ( 0, -3),
               ( 2, 2), (2, -2), (-2, 2), (-2, -2)]

type

  Hopido = object
    grid: seq[seq[int]]
    nRows, nCols: int
    totalToFill : Natural

  Neighbor = (int, int, int)


proc initHopido(board: openArray[string]): Hopido =
  result.nRows = board.len + 6
  result.nCols = board[0].len + 6
  result.grid = newSeqWith(result.nRows, repeat(-1, result.nCols))

  for row in 0..board.high:
    for col in 0..board[0].high:
      if board[row][col] == '0':
        result.grid[row + 3][col + 3] = 0
        inc result.totalToFill


proc countNeighbors(hopido: Hopido; row, col: Natural): int =
  for (x, y) in Moves:
    if hopido.grid[row + y][col + x] == 0:
      inc result


proc neighbors(hopido: Hopido; row, col: Natural): seq[Neighbor] =
  for (x, y) in Moves:
    if hopido.grid[row + y][col + x] == 0:
      let num = hopido.countNeighbors(row + y, col + x) - 1
      result.add (row + y, col + x, num)


proc solve(hopido: var Hopido; row, col, count: Natural): bool =

  if count > hopido.totalTofill: return true

  var nbrs = hopido.neighbors(row, col)
  if nbrs.len == 0 and count != hopido.totalToFill:
    return false

  nbrs.sort(proc(a, b: Neighbor): int = cmp(a[2], b[2]))

  for (row, col, _) in nbrs:
    hopido.grid[row][col] = count
    if hopido.solve(row, col, count + 1):
      return true
    hopido.grid[row][col] = 0


proc findSolution(hopido: var Hopido) =
  var pos = -1
  var row, col: Natural

  while true:
    while true:
      inc pos
      row = pos div hopido.nCols
      col = pos mod hopido.nCols
      if hopido.grid[row][col] != -1:
        break
    hopido.grid[row][col] = 1
    if hopido.solve(row, col, 2):
      break
    hopido.grid[row][col] = 0
    if pos >= hopido.nRows * hopido.nCols:
      break


proc print(hopido: Hopido) =
  for row in hopido.grid:
    for val in row:
      stdout.write if val == -1: "   " else: &"{val:2} "
    echo()


when isMainModule:

  const Board = [".00.00.",
                 "0000000",
                 "0000000",
                 ".00000.",
                 "..000..",
                 "...0..."]

  var hopido = initHopido(Board)
  hopido.findSolution()
  hopido.print()
