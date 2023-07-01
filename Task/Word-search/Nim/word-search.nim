import random, sequtils, strformat, strutils

const

  Dirs = [[1,  0], [ 0,  1], [ 1, 1],
          [1, -1],           [-1, 0],
          [0, -1], [-1, -1], [-1, 1]]

  NRows = 10
  NCols = 10
  GridSize = NRows * NCols
  MinWords = 25

type Grid = ref object
  numAttempts: Natural
  cells: array[NRows, array[NCols, char]]
  solutions: seq[string]

proc readWords(filename: string): seq[string] =

  const MaxLen = max(NRows, NCols)

  for word in filename.lines():
    if word.len in 3..MaxLen:
      if word.allCharsInSet(Letters):
        result.add word.toLowerAscii


proc placeMessage(grid: var Grid; msg: string): int =
  let msg = msg.map(toUpperAscii).filter(isUpperAscii).join()
  if msg.len in 1..<GridSize:
    let gapSize = GridSize div msg.len
    for i in 0..msg.high:
      let pos = i * gapSize + rand(gapSize - 1)
      grid.cells[pos div NCols][pos mod NCols] = msg[i]
    result = msg.len


proc tryLocation(grid: var Grid; word: string; dir, pos: Natural): int =
  let row = pos div NCols
  let col = pos mod NCols
  let length = word.len

  # Check bounds.
  if (Dirs[dir][0] == 1 and (length + col) > NCols) or
     (Dirs[dir][0] == -1 and (length - 1) > col) or
     (Dirs[dir][1] == 1 and (length + row) > NRows) or
     (Dirs[dir][1] == -1 and (length - 1) > row):
    return 0

  # Check cells.
  var r = row
  var c = col
  for ch in word:
    if grid.cells[r][c] != '\0' and grid.cells[r][c] != ch: return 0
    c += Dirs[dir][0]
    r += Dirs[dir][1]

  # Place.
  r = row
  c = col
  var overlaps = 0
  for i, ch in word:
    if grid.cells[r][c] == ch: inc overlaps
    else: grid.cells[r][c] = ch
    if i < word.high:
      c += Dirs[dir][0]
      r += Dirs[dir][1]

  let lettersPlaced = length - overlaps
  if lettersPlaced > 0:
    grid.solutions.add &"{word:<10} ({col}, {row}) ({c}, {r})"

  result = lettersPlaced


proc tryPlaceWord(grid: var Grid; word: string): int =
  let randDir = rand(Dirs.high)
  let randPos = rand(GridSize - 1)

  for dir in 0..Dirs.high:
    let dir = (dir + randDir) mod Dirs.len
    for pos in 0..<GridSize:
      let pos = (pos + randPos) mod GridSize
      let lettersPlaced = grid.tryLocation(word, dir, pos)
      if lettersPlaced > 0:
        return lettersPlaced


proc initGrid(words: seq[string]): Grid =
  var words = words
  for numAttempts in 1..100:
    words.shuffle()
    new(result)
    let messageLen = result.placeMessage("Rosetta Code")
    let target = GridSize - messageLen

    var cellsFilled = 0
    for word in words:
      cellsFilled += result.tryPlaceWord(word)
      if cellsFilled == target:
        if result.solutions.len >= MinWords:
          result.numAttempts = numAttempts
          return
        # Grid is full but we didn't pack enough words: start over.
        break

proc printResult(grid: Grid) =
  if grid.isNil or grid.numAttempts == 0:
    echo "No grid to display."
    return

  let size = grid.solutions.len
  echo "Attempts: ", grid.numAttempts
  echo "Number of words: ", size

  echo "\n    0  1  2  3  4  5  6  7  8  9\n"
  for r in 0..<NRows:
    echo &"{r}   ", grid.cells[r].join("  ")
  echo()

  for i in countup(0, size - 2, 2):
    echo grid.solutions[i], "   ", grid.solutions[i + 1]
  if (size and 1) == 1:
    echo grid.solutions[^1]


randomize()
let grid = initGrid("unixdict.txt".readWords())
grid.printResult()
