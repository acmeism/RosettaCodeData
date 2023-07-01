import random, strutils

type

  Direction {.pure.} = enum None, Up, Left, Down, Right

  Maze = object
    cells: seq[string]
    hwalls: seq[string]
    vwalls: seq[string]


####################################################################################################
# Maze creation.

func initMaze(rows, cols: Positive): Maze =
  ## Initialize a maze description.
  var h = repeat('-', cols)
  var v = repeat("|", cols)
  for i in 0..<rows:
    result.cells.add newString(cols)
    result.hwalls.add h
    result.vwalls.add v


proc gen(maze: var Maze; r, c: Natural) =
  ## Generate a maze starting from point (r, c).

  maze.cells[r][c] = ' '
  var dirs = [Up, Left, Down, Right]
  dirs.shuffle()
  for dir in dirs:
    case dir
    of None:
      discard
    of Up:
      if r > 0 and maze.cells[r-1][c] == '\0':
        maze.hwalls[r][c] = chr(0)
        maze.gen(r-1, c)
    of Left:
      if c > 0 and maze.cells[r][c-1] == '\0':
        maze.vwalls[r][c] = chr(0)
        maze.gen(r, c-1)
    of Down:
      if r < maze.cells.high and maze.cells[r+1][c] == '\0':
        maze.hwalls[r+1][c] = chr(0)
        maze.gen(r+1, c)
    of Right:
      if c < maze.cells[0].high and maze.cells[r][c+1] == '\0':
        maze.vwalls[r][c+1] = chr(0)
        maze.gen(r, c+1)


proc gen(maze: var Maze) =
  ## Generate a maze, choosing a random starting point.
  maze.gen(rand(maze.cells.high), rand(maze.cells[0].high))


####################################################################################################
# Maze solving.

proc solve(maze: var Maze; ra, ca, rz, cz: Natural) =
  ## Solve a maze by finding the path from point (ra, ca) to point (rz, cz).

  proc rsolve(maze: var Maze; r, c: Natural; dir: Direction): bool {.discardable.} =
    ## Recursive solver.

    if r == rz and c == cz:
      maze.cells[r][c] = 'F'
      return true

    if dir != Down and maze.hwalls[r][c] == '\0':
      if maze.rSolve(r-1, c, Up):
        maze.cells[r][c] = '^'
        maze.hwalls[r][c] = '^'
        return true

    if dir != Up and r < maze.hwalls.high and maze.hwalls[r+1][c] == '\0':
      if maze.rSolve(r+1, c, Down):
        maze.cells[r][c] = 'v'
        maze.hwalls[r+1][c] = 'v'
        return true

    if dir != Left and c < maze.vwalls[0].high and maze.vwalls[r][c+1] == '\0':
      if maze.rSolve(r, c+1, Right):
        maze.cells[r][c] = '>'
        maze.vwalls[r][c+1] = '>'
        return true

    if dir != Right and maze.vwalls[r][c] == '\0':
      if maze.rSolve(r, c-1, Left):
        maze.cells[r][c] = '<'
        maze.vwalls[r][c] = '<'
        return true


  maze.rsolve(ra, ca, None)
  maze.cells[ra][ca] = 'S'


####################################################################################################
# Maze display.

func `$`(maze: Maze): string =
  ## Return the string representation fo a maze.

  const
    HWall = "+---"
    HOpen = "+   "
    VWall = "|   "
    VOpen = "    "
    RightCorner = "+\n"
    RightWall = "|\n"

  for r, hw in maze.hwalls:

    for h in hw:
      if h == '-' or r == 0:
        result.add HWall
      else:
        result.add HOpen
        if h notin {'-', '\0'}: result[^2] = h
    result.add RightCorner

    for c, vw in maze.vwalls[r]:
      if vw == '|' or c == 0:
        result.add VWall
      else:
        result.add VOpen
        if vw notin {'|', '\0'}: result[^4] = vw
      if maze.cells[r][c] != '\0': result[^2] = maze.cells[r][c]
    result.add RightWall

  for _ in 1..maze.hwalls[0].len:
    result.add HWall
  result.add RightCorner


#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  const
    Width = 8
    Height = 8

  randomize()
  var maze = initMaze(Width, Height)
  maze.gen()
  var ra, rz = rand(Width - 1)
  var ca, cz = rand(Height - 1)
  while rz == ra and cz == ca:
    # Make sur starting and ending points are different.
    rz = rand(Width - 1)
    cz = rand(Height - 1)
  maze.solve(ra, ca , rz, cz)
  echo maze
