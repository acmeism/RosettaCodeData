{.this: self.}

type
  Sudoku = ref object
    grid : array[81, int]
    solved : bool

proc `$`(self: Sudoku): string =
  var sb: string = ""
  for i in 0..8:
    for j in 0..8:
      sb &= $grid[i * 9 + j]
      sb &= " "
      if j == 2 or j == 5:
        sb &= "| "
    sb &= "\n"
    if i == 2 or i == 5:
      sb &= "------+------+------\n"
  sb

proc init(self: Sudoku, rows: array[9, string]) =
  for i in 0..8:
    for j in 0..8:
      grid[9 * i + j] = rows[i][j].int - '0'.int

proc checkValidity(self: Sudoku, v, x, y: int): bool =
  for i in 0..8:
    if grid[y * 9 + i] == v or grid[i * 9 + x] == v:
      return false
  var startX = (x div 3) * 3
  var startY = (y div 3) * 3
  for i in startY..startY + 2:
    for j in startX..startX + 2:
      if grid[i * 9 + j] == v:
        return false
  result = true

proc placeNumber(self: Sudoku, pos: int) =
  if solved:
    return
  if pos == 81:
    solved = true
    return
  if grid[pos] > 0:
    placeNumber(pos + 1)
    return
  for n in 1..9:
    if checkValidity(n, pos mod 9, pos div 9):
      grid[pos] = n
      placeNumber(pos + 1)
      if solved:
        return
      grid[pos] = 0

proc solve(self: Sudoku) =
  echo "Starting grid:\n\n", $self
  placeNumber(0)
  if solved:
    echo "Solution:\n\n", $self
  else:
    echo "Unsolvable!"

var rows = ["850002400",
            "720000009",
            "004000000",
            "000107002",
            "305000900",
            "040000000",
            "000080070",
            "017000000",
            "000036040"]

var puzzle = Sudoku()
puzzle.init(rows)
puzzle.solve()
