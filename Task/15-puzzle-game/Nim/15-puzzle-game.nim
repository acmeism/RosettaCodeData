import random, terminal

type
  Tile = uint8
  Board = array[16, Tile]

type
  Operation = enum
    opInvalid
    opUp
    opDown
    opLeft
    opRight
    opQuit
    opRestart

func charToOperation(c: char): Operation =
  case c
  of 'w', 'W': opUp
  of 'a', 'A': opLeft
  of 's', 'S': opDown
  of 'd', 'D': opRight
  of 'q', 'Q': opQuit
  of 'r', 'R': opRestart
  else: opInvalid

proc getKey(): Operation =
  var c = getch()
  if c == '\e':
    c = getch()
    if c == '[':
      case getch()
      of 'A': opUp
      of 'D': opLeft
      of 'B': opDown
      of 'C': opRight
      else: opInvalid
    else: charToOperation c
  else: charToOperation c

func isSolved(board: Board): bool =
  for i in 0..<board.high:
    if i != board[i].int - 1:
      return false
  true

func findTile(b: Board, n: Tile): int =
  for i in 0..b.high:
    if b[i] == n:
      return i

func canSwap(a, b: int): bool =
  let dist = a - b
  dist == 4 or dist == -4 or
    (dist == 1 and a mod 4 != 0) or
    (dist == -1 and b mod 4 != 0)

func pad(i: Tile): string =
  if i == 0:
    "│  "
  elif i < 10:
    "│ " & $i
  else:
    "│" & $i

proc draw(b: Board) =
  echo "┌──┬──┬──┬──┐\n",
     b[0].pad, b[1].pad, b[2].pad, b[3].pad,
     "│\n├──┼──┼──┼──┤\n",
     b[4].pad, b[5].pad, b[6].pad, b[7].pad,
     "│\n├──┼──┼──┼──┤\n",
     b[8].pad, b[9].pad, b[10].pad, b[11].pad,
     "│\n├──┼──┼──┼──┤\n",
     b[12].pad, b[13].pad, b[14].pad, b[15].pad,
     "│\n└──┴──┴──┴──┘"

proc clearScreen ()=
  for i in 1..10:
    eraseLine()
    cursorUp()

func calcPosMove(b: var Board; o: Operation; ): int =
  var posEmpty = b.findTile 0
  case o
  of opUp:    return posEmpty + 4
  of opDown:  return posEmpty - 4
  of opLeft:  return posEmpty + 1
  of opRight: return posEmpty - 1
  else: return -1

proc moveTile (b : var Board, op : Operation) : bool =
  let posMove = b.calcPosMove op
  let posEmpty = b.findTile 0
  if posMove < 16 and posMove >= 0 and canSwap(posEmpty, posMove):
    swap b[posEmpty], b[posMove]
    return true
  return false

proc shuffleBoard ( b: var Board, nSteps : int = 2000 ) =
  var opMove = @[opUp, opLeft, opDown, opRight]
  for i in 0 ..< nSteps:
    let op = opMove[rand(3)]
    discard b.moveTile op

proc generateBoard: Board =
  for i in 0..15:
    if i == 15 :
      result[i] = 0
    else:
      result[i] = (i + 1).Tile
  shuffleBoard result

when isMainModule:
  randomize()
  var
    board = generateBoard()
    empty = board.findTile 0

  block gameLoop:
    while not isSolved board:
      # draw
      draw board
      echo "Press arrow keys or WASD to move, R to Restart, Q to Quit"

      # handle input
      while true:
        let op = getKey()
        case op
        of opRestart:
          board = generateBoard()
          empty = board.findTile 0
          break
        of opQuit: break gameLoop
        of opInvalid: continue
        else:
          if board.moveTile op:
            empty = board.findTile 0
            break

      clearScreen()

    draw board
    echo "You win!"
