import std/[random, strformat, strutils, tables]
import ncurses

type
  Coords = tuple[x, y: cint]
  Digit = 0..9

const
  Width = 79
  Height = 22
  NCount = Width * Height

const
  COLOR_DEFAULT: cint = -1
  Colors = [COLOR_DEFAULT,
            COLOR_WHITE,
            COLOR_BLACK or A_BOLD.int,
            COLOR_BLUE or A_BOLD.int,
            COLOR_GREEN or A_BOLD.int,
            COLOR_CYAN or A_BOLD.int,
            COLOR_RED or A_BOLD.int,
            COLOR_MAGENTA or A_BOLD.int,
            COLOR_YELLOW or A_BOLD.int,
            COLOR_WHITE or A_BOLD.int]

type Key = enum keyNone, keyNW, keyN, keyNE, keyE, keySE, keyS, keySW, keyW, keyLeave

when defined fr:
  # Keys for French keyboard.
  const Keys = {'A': keyNW, 'Z': keyN, 'E': keyNE, 'D': keyE, 'C': keySE,
                'X': keyS, 'W': keySW, 'Q': keyW, 'L': keyLeave}.toTable()
else:
  # Keys for English keyboard.
  const Keys = {'Q': keyNW, 'W': keyN, 'E': keyNE, 'D': keyE, 'C': keySE,
                'X': keyS, 'Z': keySW, 'A': keyW, 'L': keyLeave}.toTable()

type
  Board = array[Width, array[Height, Digit]]
  Game = object
    board: Board
    cursor: Coords
    score: Natural

# Convenient indexing templates.
template `[]`(board: Board; x, y: int): Digit =
  board[x][y]
template `[]`(board: Board; coords: Coords): Digit =
  board[coords.x][coords.y]
template `[]=`(board: var Board; x, y: int; val: Digit) =
  board[x][y] = val
template `[]=`(board: var Board; coords: Coords; val: Digit) =
  board[coords.x][coords.y] = val


proc initGame(): Game =
  ## Return an initialized game.
  for y in 0..<Height:
    for x in 0..<Width:
      result.board[x, y] = rand(1..9)
  result.cursor = (rand(Width - 1).cint, rand(Height - 1).cint)
  result.board[result.cursor] = 0
  result.score = 0


proc printAt(x, y: cint; s: string; cp: cint) =
  ## Print string "s" at given position using given attributes.
  discard cp.attron()
  mvaddstr(y, x, s)
  discard cp.attroff()


proc printScore(game: Game) =
  ## Print the current score.
  move(24, 0)
  let s = &"      SCORE: {game.score}: {game.score * 100 / NCount: 0.3f}"
  printAt(0, 24, s, Colors[4] + 10)
  refresh()
  attroff(Colors[4] + 10)


proc displayBoard(game: Game) =
  ## Display the board.
  move(0, 0)
  for y in cint(0)..<Height:
    for x in cint(0)..<Width:
      let i = game.board[x, y]
      let s = if i > 0: $i else: " "
      printAt(x, y, s, i.cint + 1)
  move(game.cursor.y, game.cursor.x)
  printAt(game.cursor.x, game.cursor.y, "@", 10)
  refresh()
  attroff(10)
  move(game.cursor.y, game.cursor.x)
  curs_set(1)


proc countSteps(game: Game; n, dx, dy: cint): bool =
  ## Return true if the "n" steps move in given direction
  ## is possible.
  var t = game.cursor
  for _ in 1..n:
    inc t.x, dx
    inc t.y, dy
    if t.x notin 0..<Width or t.y notin 0..<Height or game.board[t] == 0:
      return false
  result = true


proc execute(game: var Game; dx, dy: cint) =
  ## Execute the move in given direction.
  let n = game.board[game.cursor.x + dx, game.cursor.y + dy]
  if game.countSteps(n, dx, dy):
    inc game.score, n
    for _ in 1..n:
      inc game.cursor.x, dx
      inc game.cursor.y, dy
      game.board[game.cursor] = 0


proc existsMoves(game: Game): bool =
  ## Return true if there is still possible moves
  ## from the current position.
  for dx in cint(-1)..1:
    for dy in cint(-1)..1:
      if dx == 0 and dy == 0: continue
      let x = game.cursor.x + dx
      let y = game.cursor.y + dy
      if x in 0..<Width and y in 0..<Height:
        let n = game.board[x, y]
        if n > 0 and game.countSteps(n, dx, dy):
          return true


proc play() =
  ## Play the game.
  var game: Game
  initscr()
  use_default_colors()
  start_color()
  for i in cint(0)..Colors.high:
    init_extended_pair(i + 1, Colors[i], -1)
    init_extended_pair(i + 11, Colors[i], 2)
  cbreak()
  noecho()

  # Main loop.
  while true:
    curs_set(0)
    game = initGame()
    game.printScore()

    # Current game loop.
    while true:
      game.displayBoard()
      let key = Keys.getOrDefault(getch().char.toUpperAscii(), keyNone)
      case key
      of keyNW:
        if game.cursor.x > 0 and game.cursor.y > 0:
          game.execute(-1, -1)
      of keyN:
        if game.cursor.y > 0:
          game.execute(0, -1)
      of keyNE:
        if game.cursor.x < Width - 1 and game.cursor.y > 0:
          game.execute(1, -1)
      of keyE:
        if game.cursor.x < Width - 1:
          game.execute(1, 0)
      of keySE:
        if game.cursor.x < Width - 1 and game.cursor.y < Height - 1:
          game.execute(1, 1)
      of keyS:
        if game.cursor.y < Height - 1:
          game.execute(0, 1)
      of keySW:
        if game.cursor.x > 0 and game.cursor.y < Height - 1:
          game.execute(-1, 1)
      of keyW:
        if game.cursor.x > 0:
          game.execute(-1, 0)
      of keyLeave:
        return
      of keyNone:
        discard
      game.printScore()
      if not game.existsMoves():
        break

    # Game is over.
    game.displayBoard()
    let cp: cint = 10
    printAt(19,  8, "+----------------------------------------+", cp)
    printAt(19,  9, "|               GAME OVER                |", cp)
    printAt(19, 10, "|            PLAY AGAIN(Y/N)?            |", cp)
    printAt(19, 11, "+----------------------------------------+", cp)
    move(10, 48)
    curs_set(1)
    refresh()
    let yn = char(getch()).toUpperAscii()
    if yn != 'Y': return


randomize()
play()
nocbreak()
onecho()
endwin()
curs_set(1)
