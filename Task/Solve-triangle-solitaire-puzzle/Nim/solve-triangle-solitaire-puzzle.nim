import sequtils, strutils

type
  Solution = tuple[peg, over, land: int]
  Board = array[16, bool]


const
  EmptyStart = 1
  JumpMoves = [@[],
               @[(2, 4), (3, 6)],
               @[(4, 7), (5, 9)],
               @[(5, 8), (6, 10)],
               @[(2, 1), (5, 6), (7, 11), (8, 13)],
               @[(8, 12), (9, 14)],
               @[(3, 1), (5, 4), (9, 13), (10, 15)],
               @[(4, 2), (8, 9)],
               @[(5, 3), (9, 10)],
               @[(5, 2), (8, 7)],
               @[(9, 8)],
               @[(12, 13)],
               @[(8, 5), (13, 14)],
               @[(8, 4), (9, 6), (12, 11), (14, 15)],
               @[(9, 5), (13, 12)],
               @[(10, 6), (14, 13)]]


func initBoard(): Board =
  for i in 1..15: result[i] = true
  result[EmptyStart] = false


proc draw(board: Board) =
  var pegs: array[16, char]
  for peg in pegs.mitems: peg = '-'
  for i in 1..15:
    if board[i]:
      pegs[i] = i.toHex(1)[0]
  echo "       $#".format(pegs[1])
  echo "      $# $#".format(pegs[2], pegs[3])
  echo "     $# $# $#".format(pegs[4], pegs[5], pegs[6])
  echo "    $# $# $# $#".format(pegs[7], pegs[8], pegs[9], pegs[10])
  echo "   $# $# $# $# $#".format(pegs[11], pegs[12], pegs[13], pegs[14], pegs[15])


func solved(board: Board): bool = board.count(true) == 1


proc solve(board: var Board; solutions: var seq[Solution]) =
  if board.solved: return
  for peg in 1..15:
    if board[peg]:
      for (over, land) in JumpMoves[peg]:
        if board[over] and not board[land]:
          let saveBoard = board
          board[peg]  = false
          board[over] = false
          board[land] = true
          solutions.add (peg, over, land)
          board.solve(solutions)
          if board.solved: return   # otherwise back-track.
          board = saveBoard
          discard solutions.pop()

var board = initBoard()
var solutions: seq[Solution]
board.solve(solutions)
board = initBoard()
board.draw()
echo "Starting with peg $# removed\n".format(EmptyStart.toHex(1))
for (peg, over, land) in solutions:
  board[peg] = false
  board[over] = false
  board[land] = true
  board.draw()
  echo "Peg $1 jumped over $2 to land on $3\n".format(peg.toHex(1), over.toHex(1), land.toHex(1))
