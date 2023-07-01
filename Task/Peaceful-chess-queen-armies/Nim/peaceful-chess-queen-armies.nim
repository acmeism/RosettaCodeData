import sequtils, strformat

type

  Piece {.pure.} = enum Empty, Black, White
  Position = tuple[x, y: int]


func isAttacking(queen, pos: Position): bool =
  queen.x == pos.x or queen.y == pos.y or abs(queen.x - pos.x) == abs(queen.y - pos.y)


func place(m, n: int; blackQueens, whiteQueens: var seq[Position]): bool =

  if m == 0: return true

  var placingBlack = true
  for i in 0..<n:
    for j in 0..<n:

      block inner:
        let pos: Position = (i, j)
        for queen in blackQueens:
          if queen == pos or not placingBlack and queen.isAttacking(pos):
            break inner
        for queen in whiteQueens:
          if queen == pos or placingBlack and queen.isAttacking(pos):
            break inner

        if placingBlack:
          blackQueens.add pos
        else:
          whiteQueens.add pos
          if place(m - 1, n, blackQueens, whiteQueens): return true
          discard blackQueens.pop()
          discard whiteQueens.pop()
        placingBlack = not placingBlack

  if not placingBlack:
    discard blackQueens.pop()


proc printBoard(n: int; blackQueens, whiteQueens: seq[Position]) =

  var board = newSeqWith(n, newSeq[Piece](n))   # Initialized to Empty.

  for queen in blackQueens:
    board[queen.x][queen.y] = Black
  for queen in whiteQueens:
    board[queen.x][queen.y] = White

  for i in 0..<n:
    for j in 0..<n:
      stdout.write case board[i][j]
                   of Black: "B "
                   of White: "W "
                   of Empty: (if (i and 1) == (j and 1): "• " else: "◦ ")
    stdout.write '\n'

  echo ""


const Nms = [(2, 1), (3, 1), (3, 2), (4, 1), (4, 2), (4, 3),
             (5, 1), (5, 2), (5, 3), (5, 4), (5, 5),
             (6, 1), (6, 2), (6, 3), (6, 4), (6, 5), (6, 6),
             (7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7)]

for (n, m) in Nms:
  echo &"{m} black and {m} white queens on a {n} x {n} board:"
  var blackQueens, whiteQueens: seq[Position]
  if place(m, n, blackQueens, whiteQueens):
    printBoard(n, blackQueens, whiteQueens)
  else:
    echo "No solution exists.\n"
