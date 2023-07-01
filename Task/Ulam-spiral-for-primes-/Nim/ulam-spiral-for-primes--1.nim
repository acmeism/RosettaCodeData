import strutils

const N = 51  # Grid width and height.

type
  Vec2 = tuple[x, y: int]
  Grid = array[N, array[N, string]]

const Deltas: array[4, Vec2] = [(0, 1), (-1, 0), (0, -1), (1, 0)]


proc `+`(v1, v2: Vec2): Vec2 =
  ## Vector addition.
  (v1.x + v2.x, v1.y + v2.y)


proc isPrime(n: Positive): bool =
  ## Check if a number is prime.
  if n == 1: return false
  if (n and 1) == 0: return n == 2
  if (n mod 3) == 0: return n == 3
  var delta = 2
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, delta
    delta = 6 - delta
  return true


proc fill(grid: var Grid; start: Positive = 1) =
  ## Fill the grid using Ulam algorithm.

  template isEmpty(pos: Vec2): bool = grid[pos.x][pos.y].len == 0

  # Fill the grid with successive numbers (as strings).
  var pos: Vec2 = (N div 2, N div 2)
  grid[pos.x][pos.y] = $start
  var currIdx = 3
  for n in (start + 1)..<(start + N * N):
    let nextIdx = (currIdx + 1) and 3
    var nextPos = pos + Deltas[nextIdx]
    if nextPos.isEmpty():
      # Direction change is OK.
      currIdx = nextIdx
    else:
      # Continue in same direction.
      nextPos = pos + Deltas[currIdx]
    pos = move(nextPos)
    grid[pos.x][pos.y] = $n

  # Replace the values with a symbol (if prime) or a space (if composite).
  for row in 0..<N:
    for col in 0..<N:
      grid[row][col] = if grid[row][col].parseInt().isPrime(): "• " else: "  "


var grid: Grid
grid.fill()
for row in grid:
  echo row.join()
