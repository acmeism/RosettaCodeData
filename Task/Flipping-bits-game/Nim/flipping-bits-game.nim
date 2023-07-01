import random, strformat, strutils

type
  Bit = range[0..1]
  Board = array[3, array[3, Bit]]


#---------------------------------------------------------------------------------------------------

func flipRow(board: var Board; row: int) =
  for cell in board[row].mitems:
    cell = 1 - cell

#---------------------------------------------------------------------------------------------------

func flipCol(board: var Board; col: int) =
  for row in board.mitems:
    row[col] = 1 - row[col]

#---------------------------------------------------------------------------------------------------

proc initBoard(target: Board): Board =

  # Starting from the target we make 9 random row or column flips.
  result = target
  for _ in 1..9:
    if rand(1) == 0:
      result.flipRow(rand(2))
    else:
      result.flipCol(rand(2))

#---------------------------------------------------------------------------------------------------

proc print(board: Board; label: string) =

  echo &"{label}:"
  echo "  | a b c"
  echo "---------"
  for r, row in board:
    stdout.write &"{r + 1} |"
    for cell in row: stdout.write &" {cell}"
    echo ""
  echo ""


#———————————————————————————————————————————————————————————————————————————————————————————————————

var target, board: Board

randomize()

# Initialize target.
for row in target.mitems:
  for cell in row.mitems:
    cell = rand(1)

# Initialize board and ensure it differs from the target i.e. game not already over!
while true:
  board = initBoard(target)
  if board != target:
    break

target.print("TARGET")
board.print("OPENING BOARD")

var flips = 0
while board != target:

  # Get input from player.
  var isRow = true
  var n = -1
  while n < 0:
    stdout.write "Enter row number or column letter to be flipped: "
    stdout.flushFile()
    let input = stdin.readLine()
    let ch = if input.len > 0: input[0].toLowerAscii else: '0'
    if ch notin "123abc":
      echo "Must be 1, 2, 3, a, b or c"
      continue
    if ch in '1'..'3':
      n = ord(ch) - ord('1')
    else:
      isRow = false
      n = ord(ch) - ord('a')

  # Update board.
  inc flips
  if isRow: board.flipRow(n) else: board.flipCol(n)
  target.print("\nTARGET")
  let plural = if flips == 1: "" else: "S"
  board.print(&"BOARD AFTER {flips} FLIP{plural}")

let plural = if flips == 1: "" else: "s"
echo &"You’ve succeeded in {flips} flip{plural}"
