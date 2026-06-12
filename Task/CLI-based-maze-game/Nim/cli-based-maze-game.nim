import os, random, sequtils, strutils, std/exitprocs, locks
import ncurses

const

  KeyUp = 259
  Keydown = 258
  KeyLeft = 260
  KeyRight = 261

  Mx = 69 # No of columns (1..Mx), must be odd.
  My = 31 # No of rows (1..My), must be odd.
  Treasure = '$'
  TreasureDb= 3 # How many $ signs will be placed.
  Way = ' '
  Wall = 'X'
  Doors = 20 # No of doors.
  DoorCenter = 'o'
  DoorWingVertical = '|'
  DoorWingHorizontal = '-'
  Hero = '@'
  DeadHero = '+'
  NumberOfBombs = 5
  Bomb = 'b'
  NumberOfMonsters = 20
  Monster = '*'
  WeakMonster = '.'
  MonsterWeaknessProbability = 25
    # The higher the above number, the lower the chance that a strong monster will become weak.
  MonsterIntensifiesProbability = 5
    # The higher the number above, the lower the chance that a weak monster will get stronger.

  HelpText = """
  Maze game.

The object of the game is to get all the treasures. The symbol of the treasure is the $ sign.
Help (display this text): press ? or h
Exit: press Esc or q
You can detonate a bomb by pressing b, but only as long as your bomb remains.
A bomb destroys every wall around the player (the outermost, framing of the maze
except for its walls), but it won't kill monsters.
The bomb does not destroy diagonally, only vertically and horizontally.
The bomb will not destroy the doors or the treasure.
You can also find bombs in the maze, represented by the letter b. If you step on them,
you got the bomb with it, that is, the number of your bombs increases, for later use.
The game ends when you have acquired all the treasures.
The maze has not only walls but also revolving doors.
The revolving door, if horizontal, looks like this: -o-
If vertical, like this:
 |
 o
 |
The center of the revolving door is represented by the character o, the wings by the line.
The revolving door can be rotated if you take your wing in the right direction with your character,
and if nothing stands in the way of rotation.
The player is represented by @ in the game, and his starting point is always in the lower left corner.
There is a possibility of a little cheating in the game: each press of the letter c is one increases
the amount of your bombs.
"""

type

  Direction = enum dirLeft, dirRight, dirUp, dirDown

  Position = tuple[x, y: int]

  Game = object
    grid: array[1..My, array[1..Mx, char]]
    scoords: array[1..NumberOfMonsters, Position]
    showHelp: bool
    terminate: bool
    treasureCounter: Natural
    bombs: Natural
    x, y: Natural

const
  None: Position = (0, 0)
  Dy = [-1, 1, 0, 0]
  Dx = [0, 0, -1, 1]

var gameLock: Lock


proc genFlags(n: static int): array[1..n, bool] =
  for i in countup(1, n, 2):
    result[i] = true


proc initGame(): Game =

  result.bombs = 3

  for x in 1..Mx:
    result.grid[1][x] = Wall
    result.grid[My][x] = Wall
  for y in 2..<My:
    result.grid[y][1] = Wall
    for x in 2..<Mx: result.grid[y][x] = Way
    result.grid[y][Mx] = Wall

  var colFlags = genFlags(Mx)
  var rowFlags = genFlags(My)

  while colFlags.anyIt(it) or rowFlags.anyIt(it):
    let direction = Direction(rand(3))
    let j = rand(1..(if direction <= dirRight: My else: Mx)) div 2 * 2 + 1
    case direction
    of dirLeft:
      if rowFlags[j]:
        for r in 1..<Mx:
          if result.grid[j][r] != Wall and result.grid[j][r+1] != Wall:
            result.grid[j][r] = Wall
        rowFlags[j] = false
    of dirRight:
      if rowFlags[j]:
        for r in countdown(Mx, 3):
          if result.grid[j][r-1] != Wall and result.grid[j][r-2] != Wall:
            result.grid[j][r-1] = Wall
        rowFlags[j] = false
    of dirUp:
      if colFlags[j]:
        for c in countdown(My, 3):
          if result.grid[c-1][j] != Wall and result.grid[c-2][j] != Wall:
            result.grid[c-1][j] = Wall
        colFlags[j] = false
    of dirDown:
      if colFlags[j]:
        for c in 1..<My:
          if result.grid[c][j] != Wall and result.grid[c+1][j] != Wall:
            result.grid[c][j] = Wall
        colFlags[j] = false

  var doorsPlaced = 0
  while doorsPlaced < Doors:
    let x = rand(3..Mx-2)
    let y = rand(3..My-2)
    if result.grid[y][x] != Way and
        result.grid[y-1][x-1] == Way and         # top left corner free
        result.grid[y-1][x+1] == Way and         # top right corner free
        result.grid[y+1][x-1] == Way and         # left corner free
        result.grid[y+1][x+1] == Way:            # right corner free
      # Let's see if we can put a vertical door.
      if result.grid[y-1][x] == Wall and         # wall above the current position
          result.grid[y-2][x] == Wall and        # wall above the current position
          result.grid[y+1][x] == Wall and        # wall below the current position
          result.grid[y+2][x] == Wall and        # wall below the current position
          result.grid[y][x-1] == Way and         # left neighbor free
          result.grid[y][x+1] == Way:            # right neighbor free
        result.grid[y][x] = DoorCenter
        result.grid[y-1][x] = DoorWingVertical
        result.grid[y+1][x] = DoorWingVertical
        inc doorsPlaced
      # Let's see if we can put a horizontal door.
      elif result.grid[y][x-1] == Wall and       # wall left of the current position
            result.grid[y][x-2] == Wall and      # wall left of the current position
            result.grid[y][x+1] == Wall and      # wall right of the current position
            result.grid[y][x+2] == Wall and      # wall right of the current position
            result.grid[y+1][x] == Way and       # above neighbor free
            result.grid[y-1][x] == Way:          # below neighbor free
          result.grid[y][x] = DoorCenter
          result.grid[y][x-1] = DoorWingHorizontal
          result.grid[y][x+1] = DoorWingHorizontal
          inc doorsPlaced

  const Stuff = [(TreasureDb, Treasure),
                 (NumberOfBombs, Bomb),
                 (NumberOfMonsters, WeakMonster)]   # At first, all monsters are weak.

  for (n, what) in Stuff:
    var iter = 1
    var n = n
    while n > 0:
      let x = rand(1..Mx)
      let y = rand(1..My)
      if result.grid[y][x] == Way:
        result.grid[y][x] = what
        if what == WeakMonster:
          result.scoords[n] = (x, y)
        dec n
      inc iter
      assert iter <= 10_000    # (sanity check)

  result.x = 1
  result.y = My - 2
  result.grid[My - 2][1] = Hero


proc draw(game: ptr Game) {.thread.} =
  cursSet(0)
  while true:
    acquire gameLock
    if game.showHelp:
      erase()
      addStr HelpText
      while getch() == -1: sleep 10
      erase()
      game.showHelp = false
    erase()
    move(0, 0)
    for row in game.grid:
      addstr row.join("") & '\n'
    addstr "\n\nCollected treasures = $1     Bombs = $2\n".format(game.treasureCounter, game.bombs)
    refresh()
    if game.terminate: break
    release gameLock
    sleep 200
  release gameLock


proc monsterStepFinder(game: ptr Game; sx, sy: int): Position =
  result = None
  var m = [0, 1, 2, 3]
  m.shuffle()
  for i in m:
    let nx = sx + Dx[i]
    let ny = sy + Dy[i]
    if ny in 1..My and nx in 1..Mx and game.grid[ny][nx] in [Way, Hero]:
      result = (nx, ny)


proc monsterMove(game: ptr Game) {.thread.} =
  while not game.terminate:
    acquire gameLock
    let active = rand(1..NumberOfMonsters)
    let (sx, sy) = game.scoords[active]
    if sx != 0:
      let ch = game.grid[sy][sx]
      if ch == Monster:
        if rand(1..MonsterWeaknessProbability) == 1:
          game.grid[sy][sx] = WeakMonster
        else:
          let monster = game.monsterStepFinder(sx, sy)
          if monster != None:
            if game.grid[monster.y][monster.x] == Hero:
              game.grid[monster.y][monster.x] = DeadHero
              game.terminate = true
              break
            game.grid[sy][sx] = Way
            game.grid[monster.y][monster.x] = Monster
            game.scoords[active] = monster
      elif ch == WeakMonster:
        if rand(1..MonsterIntensifiesProbability) == 1:
          game.grid[sy][sx] = Monster
        else:
          let monster = game.monsterStepFinder(sx, sy)
          if monster != None:
            game.grid[sy][sx] = Way
            if game.grid[monster.y][monster.x] != Hero:
              game.grid[monster.y][monster.x] = WeakMonster
              game.scoords[active] = monster
            else:
              game.scoords[active] = None
    release gameLock
    sleep 100

  release gameLock


proc rotateDoor(game: var Game; nx, ny: int) =
  for i in 1..4:
    let
      wy = Dy[i-1]
      wx = Dx[i-1]
      cy = ny + wy
      cx = nx + wx
    if game.grid[cy][cx] == DoorCenter:
      if game.grid[cy-1][cx-1] == Way and
         game.grid[cy-1][cx+1] == Way and
         game.grid[cy+1][cx-1] == Way and
         game.grid[cy+1][cx+1] == Way:  # four corners empty
        let py = Dy[^i]
        let px = Dx[^i]
        if game.grid[cy+py][cx+px] == Way and
           game.grid[cy-py][cx-px] == Way:  # swung door empty
          let door = game.grid[ny][nx]
          let flip = if door == DoorWingVertical: DoorWingHorizontal else: DoorWingVertical
          game.grid[cy+py][cx+px] = flip
          game.grid[cy-py][cx-px] = flip
          game.grid[cy+wy][cx+wx] = Way
          game.grid[cy-wy][cx-wx] = Way
      break


proc keyboard(game: var Game; win: PWindow) =
  while not game.terminate:
    var key = -1
    while key == -1 and not game.terminate:
      sleep 10
      key = win.wgetch()
    acquire gameLock
    case key
    of ord('\e'), ord('q'):
      game.terminate = true
    of ord('b'):
      if game.bombs != 0:
        dec game.bombs
        for i in 0..3:
          let nx = game.x + Dx[i]
          let ny = game.y + Dy[i]
          if ny in 2..<My and nx in 2..<Mx and game.grid[ny][nx] == Wall:
            game.grid[ny][nx] = Way
    of ord('c'):
      inc game.bombs
    of ord('?'), ord('h'):
      game.showHelp = true
    else:
      let chIndex = [KeyUp, Keydown, KeyLeft, KeyRight].find(key)
      if chIndex >= 0:
        let nx = game.x + Dx[chIndex]
        let ny = game.y + Dy[chIndex]
        if ny in 2..<My and nx in 2..<Mx:
          var ch = game.grid[ny][nx]
          if ch in [DoorWingVertical, DoorWingHorizontal]:
            game.grid[game.y][game.x] = Way   # (temp. "ghost" him)
            game.rotateDoor(nx, ny)
            game.grid[game.y][game.x] = Hero
            ch = game.grid[ny][nx]            # (maybe unaltered)
          elif ch == Monster:
            game.grid[game.y][game.x] = Way
            game.grid[ny][nx] = DeadHero
            game.y = ny
            game.x = nx
            game.terminate = true
          elif ch == Treasure:
            inc game.treasureCounter
            if game.treasureCounter == TreasureDb:
              game.terminate = true
            ch = Way
          elif ch == Bomb:
            inc game.bombs
            ch = Way
          if ch in [Way, WeakMonster]:
            game.grid[game.y][game.x] = Way
            game.grid[ny][nx] = Hero
            game.y = ny
            game.x = nx

    release gameLock

  while getch() != -1: discard   # (purge kbd buffer)


proc play() =

  randomize()
  let win = initscr()
  win.nodelay(true)
  win.keypad(true)
  noecho()
  cbreak()
  addExitProc proc() = endwin()
  addExitProc proc() = cursSet(1)
  var game = initGame()

  var tdraw, tmove: Thread[ptr Game]
  createThread(tdraw, draw, addr(game))
  createThread(tmove, monsterMove, addr(game))
  game.keyboard(win)

  joinThreads(tdraw, tmove)
  if game.treasureCounter == TreasureDb:
    addstr "\nYOU WON! Congratulations!\n"
    refresh()
    while getch() == -1: sleep(1)
  elif game.grid[game.y][game.x] == DeadHero:
    addstr "\nYOU PERISHED!\n"
    refresh()
    while getch() == -1: sleep(1)


play()
