import deques, sets, strutils

type

  Sokoban = object
    destBoard: string
    currBoard: string
    nCols: Natural
    playerX: Natural
    playerY: Natural

  Board = tuple[cur, sol: string; x, y: int]


func initSokoban(board: openArray[string]): Sokoban =
  result.nCols = board[0].len
  for row in 0..board.high:
    for col in 0..<result.nCols:
      let ch = board[row][col]
      result.destBoard.add if ch notin ['$', '@']: ch else: ' '
      result.currBoard.add if ch != '.': ch else: ' '
      if ch == '@':
        result.playerX = col
        result.playerY = row


func move(sokoban: Sokoban; x, y, dx, dy: int; trialBoard: string): string =
  let newPlayerPos = (y + dy) * sokoban.nCols + x + dx
  if trialBoard[newPlayerPos] != ' ': return
  result = trialBoard
  result[y * sokoban.nCols + x] = ' '
  result[newPlayerPos] = '@'


func push(sokoban: Sokoban; x, y, dx, dy: int; trialBoard: string): string =
  let newBoxPos = (y + 2 * dy) * sokoban.nCols + x + 2 * dx
  if trialBoard[newBoxPos] != ' ': return
  result = trialBoard
  result[y * sokoban.nCols + x] = ' '
  result[(y + dy) * sokoban.nCols + x + dx] = '@'
  result[newBoxPos] = '$'


func isSolved(sokoban: Sokoban; trialBoard: string): bool =
  for i in 0..trialBoard.high:
    if (sokoban.destBoard[i] == '.') != (trialBoard[i] == '$'): return false
  result = true


func solve(sokoban: Sokoban): string =
  var history: HashSet[string]
  history.incl sokoban.currBoard
  const Dirs = [(0, -1, 'u', 'U'), (1, 0, 'r', 'R'), (0, 1, 'd', 'D'), (-1, 0, 'l', 'L')]
  var open: Deque[Board]
  open.addLast (sokoban.currBoard, "", sokoban.playerX, sokoban.playerY)

  while open.len != 0:
    let (cur, sol, x, y) = open.popFirst()
    for dir in Dirs:
      var trial = cur
      let dx = dir[0]
      let dy = dir[1]

      # Are we standing next to a box?
      if trial[(y + dy) * sokoban.nCols + x + dx] == '$':
        # Can we push it?
        trial = sokoban.push(x, y, dx, dy, trial)
        if trial.len != 0:
          # Or did we already try this one?
          if trial notin history:
            let newSol = sol & dir[3]
            if sokoban.isSolved(trial): return newSol
            open.addLast (trial, newSol, x + dx, y + dy)
            history.incl trial

      else:
        # Try to change position.
        trial = sokoban.move(x, y, dx, dy, trial)
        if trial.len != 0 and trial notin history:
          let newSol = sol & dir[2]
          open.addLast (trial, newSol, x + dx, y + dy)
          history.incl trial

  result = "no solution"

when isMainModule:

  const Level = ["#######",
                "#     #",
                "#     #",
                "#. #  #",
                "#. $$ #",
                "#.$$  #",
                "#.#  @#",
                "#######"]

  echo Level.join("\n")
  echo()
  echo initSokoban(Level).solve()
