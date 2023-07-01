import random, strutils, terminal

const
  BoardLength = 4
  BoardSize = BoardLength * BoardLength
  Target = 2048

type
  Operation = enum
    opInvalid
    opUp
    opDown
    opLeft
    opRight
    opQuit
    opRestart

  Board = object
    len: Natural
    largestNumber: Natural
    score: Natural
    rows: array[BoardLength, array[BoardLength, Natural]]

func handleKey(c: char): Operation =
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
    else: handleKey c
  else: handleKey c

proc spawnRandom(b: var Board) =
  if b.len < BoardSize:
    var
      x = rand 0..<BoardLength
      y = rand 0..<BoardLength
    while b.rows[y][x] != 0:
      x = rand 0..<BoardLength
      y = rand 0..<BoardLength
    b.rows[y][x] = if rand(1.0) < 0.9: 2 else: 4
    inc b.len
    b.largestNumber = max(b.rows[y][x], b.largestNumber)

proc initBoard(): Board =
  spawnRandom result

func `$`(b: Board): string =
  result = "┌────┬────┬────┬────┐\n"
  for idx, val in b.rows:
    for v in val:
      result.add "│"
      result.add center(if v != 0: $v else: "", 4)
    result.add "│\n"
    if idx < high(b.rows):
      result.add "├────┼────┼────┼────┤\n"
    else:
      result.add "└────┴────┴────┴────┘"

func shift(b: var Board; o: Operation; merge = true): bool =
  const BoardRange = 0..<BoardLength
  var
    x = 0
    y = 0
    vecX: range[-1..1] = 0
    vecY: range[-1..1] = 0
  case o
  of opUp:
    vecY = 1
  of opDown:
    vecY = -1
    y = BoardLength - 1
  of opLeft: vecX = 1
  of opRight:
    vecX = -1
    x = BoardLength - 1
  else: return

  let
    startX = x
    startY = y
  while x in BoardRange and y in BoardRange:
    while b.len < BoardSize and x in BoardRange and y in BoardRange:
      let
        nextX = x + vecX
        nextY = y + vecY
        prevX = x - vecX
        prevY = y - vecY
      if b.rows[y][x] == 0:
        if nextX in BoardRange and nextY in BoardRange and
           b.rows[nextY][nextX] != 0:
          result = true
          swap b.rows[y][x], b.rows[nextY][nextX]
          if prevX in BoardRange and prevY in BoardRange:
            x = prevX
            y = prevY
            continue
      x = nextX
      y = nextY

    if merge:
      x = if vecX != 0: startX else: x
      y = if vecY != 0: startY else: y
      while x in BoardRange and y in BoardRange:
        let
          nextX = x + vecX
          nextY = y + vecY
        if b.rows[y][x] != 0:
          if nextX in BoardRange and nextY in BoardRange and
             b.rows[nextY][nextX] == b.rows[y][x]:
            result = true
            b.rows[y][x] *= 2
            b.largestNumber = max(b.rows[y][x], b.largestNumber)
            b.score += b.rows[y][x]
            b.rows[nextY][nextX] = 0
            dec b.len
        x = nextX
        y = nextY

    if vecX == 0:
      inc x
      y = startY
    elif vecY == 0:
      inc y
      x = startX
  if merge and result: discard b.shift(o, false)

func shiftable(b: Board): bool =
  for row in 0..<BoardLength:
    for col in 0..<BoardLength:
      result = result or b.rows[row][col] == 0
      if result: break
      if row < BoardLength - 1:
        result = result or b.rows[row][col] == b.rows[row + 1][col]
      if col < BoardLength - 1:
        result = result or b.rows[row][col] == b.rows[row][col + 1]

when isMainModule:
  randomize()
  var
    board = initBoard()
    highscore = 0
  block gameLoop:
    while true:
      let gameover = not board.shiftable or board.largestNumber >= Target
      echo board
      highscore = max(highscore, board.score)
      echo "Score = ", board.score, "  Highscore = ", highscore
      if not gameover:
        echo "Press arrow keys or WASD to move, R to Restart, Q to Quit"
      elif board.largestNumber >= Target:
        echo "You win! Press R to Restart, Q to Quit"
      else:
        echo "Game over! Press R to Restart, Q to Quit"
      while true:
        let op = getKey()
        case op
        of opRestart:
          board = initBoard()
          break
        of opQuit: break gameLoop
        of opInvalid: continue
        elif gameover: continue
        else:
          if board.shift op:
            board.spawnRandom
            break
      for i in 1..BoardLength + 7:
        eraseLine()
        cursorUp()
