import std/[monotimes, sequtils, strformat]

type

  Piece {.pure.} = enum Queen, Bishop, Knight
  Solver = object
    n: Natural
    board: seq[seq[bool]]
    diag1, diag2: seq[seq[int]]
    diag1Lookup, diag2Lookup: seq[bool]
    minCount: int
    layout: string

func isAttacked(s: Solver; piece: Piece; row, col: Natural): bool =
  case piece
  of Queen:
    for i in 0..<s.n:
      if s.board[i][col] or s.board[row][i]:
        return true
    result = s.diag1Lookup[s.diag1[row][col]] or s.diag2Lookup[s.diag2[row][col]]
  of Bishop:
    result = s.diag1Lookup[s.diag1[row][col]] or s.diag2Lookup[s.diag2[row][col]]:
  of Knight:
    result = s.board[row][col] or
             row + 2 < s.n and col - 1 >= 0  and s.board[row + 2][col - 1] or
             row - 2 >= 0  and col - 1 >= 0  and s.board[row - 2][col - 1] or
             row + 2 < s.n and col + 1 < s.n and s.board[row + 2][col + 1] or
             row - 2 >= 0  and col + 1 < s.n and s.board[row - 2][col + 1] or
             row + 1 < s.n and col + 2 < s.n and s.board[row + 1][col + 2] or
             row - 1 >= 0  and col + 2 < s.n and s.board[row - 1][col + 2] or
             row + 1 < s.n and col - 2 >= 0  and s.board[row + 1][col - 2] or
             row - 1 >= 0  and col - 2 >= 0  and s.board[row - 1][col - 2]

func attacks(piece: Piece; row, col, trow, tcol: int): bool =
  case piece
  of Queen:
    result = row == trow or col == tcol or abs(row - trow) == abs(col - tcol)
  of Bishop:
    result = abs(row - trow) == abs(col - tcol)
  of Knight:
    let rd = abs(trow - row)
    let cd = abs(tcol - col)
    result = (rd == 1 and cd == 2) or (rd == 2 and cd == 1)

func storeLayout(s: var Solver; piece: Piece) =
  for row in s.board:
    for cell in row:
      s.layout.add if cell: ($piece)[0] & ' ' else: ". "
    s.layout.add '\n'

func placePiece(s: var Solver; piece: Piece; countSoFar, maxCount: int) =
  if countSoFar >= s.minCount: return

  var allAttacked = true
  var ti, tj = 0
  block CheckAttacked:
    for i in 0..<s.n:
      for j in 0..<s.n:
        if not s.isAttacked(piece, i, j):
          allAttacked = false
          ti = i
          tj = j
          break CheckAttacked

  if allAttacked:
    s.minCount = countSoFar
    s.storeLayout(piece)
    return

  if countSoFar <= maxCount:
    var si = ti
    var sj = tj
    if piece == Knight:
      dec si, 2
      dec sj, 2
      if si < 0: si = 0
      if sj < 0: sj = 0

    for i in si..<s.n:
      for j in sj..<s.n:
        if not s.isAttacked(piece, i, j):
          if (i == ti and j == tj) or attacks(piece, i, j, ti, tj):
            s.board[i][j] = true
            if piece != Knight:
              s.diag1Lookup[s.diag1[i][j]] = true
              s.diag2Lookup[s.diag2[i][j]] = true
            s.placePiece(piece, countSoFar + 1, maxCount)
            s.board[i][j] = false
            if piece != Knight:
              s.diag1Lookup[s.diag1[i][j]] = false
              s.diag2Lookup[s.diag2[i][j]] = false

func initSolver(n: Positive; piece: Piece): Solver =
  result.n = n
  result.board = newSeqWith(n, newSeq[bool](n))
  if piece != Knight:
    result.diag1 = newSeqWith(n, newSeq[int](n))
    result.diag2 = newSeqWith(n, newSeq[int](n))
    for i in 0..<n:
      for j in 0..<n:
        result.diag1[i][j] = i + j
        result.diag2[i][j] = i - j + n - 1
    result.diag1Lookup = newSeq[bool](2 * n - 1)
    result.diag2Lookup = newSeq[bool](2 * n - 1)
  result.minCount = int32.high

proc main() =
  let start = getMonoTime()
  const Limits = [Queen: 10, Bishop: 10, Knight: 10]
  for piece in Piece.low..Piece.high:
    echo $piece & 's'
    echo "=======\n"
    var n = 0
    while true:
      inc n
      var solver = initSolver(n , piece)
      for maxCount in 1..(n * n):
        solver.placePiece(piece, 0, maxCount)
        if solver.minCount <= n * n:
          break
      echo &"{n:>2} × {n:<2} : {solver.minCount}"
      if n == Limits[piece]:
        echo &"\n{$piece}s on a {n} × {n} board:"
        echo '\n' & solver.layout
        break
  let elapsed = getMonoTime() - start
  echo "Took: ", elapsed

main()
