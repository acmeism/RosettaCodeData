import strutils, algorithm, sequtils, strformat

type Hidato = object
       board: seq[seq[int]]
       given: seq[int]
       start: (int, int)

proc initHidato(s: string): Hidato =
  var lines = s.splitLines()
  let cols = lines[0].splitWhitespace().len()
  let rows = lines.len()
  result.board = newSeqWith(rows + 2, newSeq[int](cols + 2))  # Make room for borders.

  for i in 0 .. result.board.high:
    for j in 0 .. result.board[0].high:
      result.board[i][j] = -1

  for r, row in lines:
    for c, cell in row.splitWhitespace().pairs():
      case cell
      of "__" :
        result.board[r + 1][c + 1] = 0
        continue
      of "." :
        continue
      else :
        let val = parseInt(cell)
        result.board[r + 1][c + 1] = val
        result.given.add(val)
        if val == 1:
          result.start = (r + 1, c + 1)
  result.given.sort()


proc solve(hidato: var Hidato; r, c, n: int; next = 0): bool =
  if n > hidato.given[^1]:
    return true
  if hidato.board[r][c] < 0:
    return false
  if hidato.board[r][c] > 0 and hidato.board[r][c] != n:
    return false
  if hidato.board[r][c] == 0 and hidato.given[next] == n:
    return false

  let back = hidato.board[r][c]
  hidato.board[r][c] = n
  for i in -1 .. 1:
    for j in -1 .. 1:
      if back == n:
        if hidato.solve(r + i, c + j, n + 1, next + 1): return true
      else:
        if hidato.solve(r + i, c + j, n + 1, next): return true
  hidato.board[r][c] = back
  result = false


proc print(hidato: Hidato) =
  for row in hidato.board:
    for val in row:
      stdout.write if val == -1: " . " elif val == 0: "__ " else: &"{val:2} "
    writeLine(stdout, "")


const Hi = """
__ 33 35 __ __  .  .  .
__ __ 24 22 __  .  .  .
__ __ __ 21 __ __  .  .
__ 26 __ 13 40 11  .  .
27 __ __ __  9 __  1  .
 .  . __ __ 18 __ __  .
 .  .  .  . __  7 __ __
 .  .  .  .  .  .  5 __"""

var hidato = initHidato(Hi)
hidato.print()
echo("")
echo("Found:")
discard hidato.solve(hidato.start[0], hidato.start[1], 1)
hidato.print()
