import random, sequtils, strformat, strscans, strutils

const LMargin = 4

type

  Cell = object
    isMine: bool
    display: char

  Grid = seq[seq[Cell]]

  Game = object
    grid: Grid
    mineCount: Natural
    minesMarked: Natural
    isOver: bool


proc initGame(m, n: Positive): Game =
  result.grid = newSeqWith(m, repeat(Cell(isMine: false, display: '.'), n))
  let min = (float(m * n) * 0.1).toInt
  let max = (float(m * n) * 0.2).toInt
  result.mineCount = min + rand(max - min)
  var rm = result.mineCount
  while rm > 0:
    let x = rand(m - 1)
    let y = rand(n - 1)
    if not result.grid[x][y].isMine:
      dec rm
      result.grid[x][y].isMine = true
  result.minesMarked = 0


template `[]`(grid: Grid; x, y: int): Cell = grid[x][y]


iterator cells(grid: var Grid): var Cell =
  for y in 0..grid[0].high:
    for x in 0..grid.high:
      yield grid[x, y]


proc display(game: Game; endOfGame: bool) =
  if not endOfGame:
    echo &"Grid has {game.mineCount} mine(s), {game.minesMarked} mine(s) marked."
  let margin = repeat(' ', LMargin)
  echo margin, toSeq(1..game.grid.len).join()
  echo margin, repeat('-', game.grid.len)
  for y in 0..game.grid[0].high:
    stdout.write align($(y + 1), LMargin)
    for x in 0..game.grid.high:
      stdout.write game.grid[x][y].display
    stdout.write '\n'


proc terminate(game: var Game; msg: string) =
  game.isOver = true
  echo msg
  var answer = ""
  while answer notin ["y", "n"]:
    stdout.write "Another game (y/n)? "
    answer = try: stdin.readLine().toLowerAscii
             except EOFError: "n"
    if answer == "y":
      game = initGame(6, 4)
      game.display(false)


proc resign(game: var Game) =
  var found = 0
  for cell in game.grid.cells:
    if cell.isMine:
      if cell.display == '?':
        cell.display = 'Y'
        inc found
      elif cell.display == 'x':
        cell.display = 'N'
  game.display(true)
  let msg = &"You found {found} out of {game.mineCount} mine(s)."
  game.terminate(msg)


proc markCell(game: var Game; x, y: int) =
  if game.grid[x, y].display == '?':
    dec game.minesMarked
    game.grid[x, y].display = '.'
  elif game.grid[x, y].display == '.':
    inc game.minesMarked
    game.grid[x, y].display = '?'


proc countAdjMines(game: Game; x, y: Natural): int =
  for j in (y - 1)..(y + 1):
    if j in 0..game.grid[0].high:
      for i in (x - 1)..(x + 1):
        if i in 0..game.grid.high:
          if game.grid[i, j].isMine:
            inc result


proc clearCell(game: var Game; x, y: int): bool =

  if x in 0..game.grid.high and y in 0..game.grid[0].high:
    if game.grid[x, y].display == '.':

      if game.grid[x, y].isMine:
        game.grid[x][y].display = 'x'
        echo "Kaboom! You lost!"
        return false

      let count = game.countAdjMines(x, y)
      if count > 0:
        game.grid[x][y].display = chr(ord('0') + count)
      else:
        game.grid[x][y].display = ' '
        for dx in -1..1:
          for dy in -1..1:
            if dx != 0 or dy != 0:
              discard game.clearCell(x + dx, y + dy)

  result = true


proc testForWin(game: var Game): bool =
  if game.minesMarked != game.mineCount: return false
  for cell in game.grid.cells:
    if cell.display == '.': return false
  result = true
  echo "You won!"


proc splitAction(game: Game; action: string): tuple[x, y: int; ok: bool] =
  var command: string
  if not action.scanf("$w $s$i $s$i$s$.", command, result.x, result.y): return
  if command.len != 1: return
  if result.x notin 1..game.grid.len or result.y notin 1..game.grid.len: return
  result.ok = true


proc printUsage() =
  echo "h or ? - this help,"
  echo "c x y  - clear cell (x,y),"
  echo "m x y  - marks (toggles) cell (x,y),"
  echo "n      - start a new game,"
  echo "q      - quit/resign the game,"
  echo "where 'x' is the (horizontal) column number and 'y' is the (vertical) row number.\n"


randomize()
printUsage()
var game = initGame(6, 4)
game.display(false)

while not game.isOver:
  stdout.write "\n>"
  let action = try: stdin.readLine().toLowerAscii
               except EOFError: "q"
  case action[0]

  of 'h', '?':
    printUsage()

  of 'n':
    game = initGame(6, 4)
    game.display(false)

  of 'c':
    let (x, y, ok) = game.splitAction(action)
    if not ok: continue
    if game.clearCell(x - 1, y - 1):
      game.display(false)
      if game.testForwin(): game.resign()
    else:
      game.resign()

  of 'm':
    let (x, y, ok) = game.splitAction(action)
    if not ok: continue
    game.markCell(x - 1, y - 1)
    game.display(false)
    if game.testForWin(): game.resign()

  of 'q':
    game.resign()

  else:
    continue
