import algorithm, sequtils, strformat, strutils

const Moves = [(1, 0), (0, 1), (-1, 0), (0, -1)]

type Numbrix = object
  grid: seq[seq[int]]
  clues: seq[int]
  totalToFill: Natural
  startRow, startCol : Natural


proc initNumbrix(board: openArray[string]): Numbrix =

  let nRows = board.len + 2
  let nCols = board[0].split(',').len + 2
  result.grid = newSeqWith(nRows, repeat(-1, nCols))
  result.totalToFill = (nRows - 2) * (nCols - 2)

  var list: seq[int]
  for r in 0..board.high:
    let row = board[r].split(',')
    for c in 0..row.high:
      let val = parseInt(row[c])
      result.grid[r + 1][c + 1] = val
      if val > 0:
        list.add val
        if val == 1:
          result.startRow = r + 1
          result.startCol = c + 1

  list.sort()
  result.clues = list


proc solve(numbrix: var Numbrix; row, col, count: Natural; nextClue: int): bool =

  if count > numbrix.totalToFill:
    return true

  let back = numbrix.grid[row][col]
  if back notin [0, count]:
    return false
  if back == 0 and nextClue < numbrix.clues.len and numbrix.clues[nextClue] == count:
    return false

  var nextClue = nextClue
  if back == count: inc nextClue

  numbrix.grid[row][col] = count
  for move in Moves:
    if numbrix.solve(row + move[1], col + move[0], count + 1, nextClue):
      return true
  numbrix.grid[row][col] = back


proc print(numbrix: Numbrix) =
  for row in numbrix.grid:
    for val in row:
      if val != -1:
        stdout.write &"{val:2} "
    echo()


when isMainModule:

  const

    Example1 = ["00,00,00,00,00,00,00,00,00",
                "00,00,46,45,00,55,74,00,00",
                "00,38,00,00,43,00,00,78,00",
                "00,35,00,00,00,00,00,71,00",
                "00,00,33,00,00,00,59,00,00",
                "00,17,00,00,00,00,00,67,00",
                "00,18,00,00,11,00,00,64,00",
                "00,00,24,21,00,01,02,00,00",
                "00,00,00,00,00,00,00,00,00"]

    Example2 = ["00,00,00,00,00,00,00,00,00",
                "00,11,12,15,18,21,62,61,00",
                "00,06,00,00,00,00,00,60,00",
                "00,33,00,00,00,00,00,57,00",
                "00,32,00,00,00,00,00,56,00",
                "00,37,00,01,00,00,00,73,00",
                "00,38,00,00,00,00,00,72,00",
                "00,43,44,47,48,51,76,77,00",
                "00,00,00,00,00,00,00,00,00"]

  for i, board in [1: Example1, 2: Example2]:
    var numbrix = initNumbrix(board)
    if numbrix.solve(numbrix.startRow, numbrix.startCol, 1, 0):
      echo &"Solution for example {i}:"
      numbrix.print()
    else:
      echo "No solution."
