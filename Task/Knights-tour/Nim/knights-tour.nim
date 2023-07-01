import algorithm, options, random, parseutils, strutils, strformat

type
  Board[N: static Positive] = array[N, array[N, int]]
  Move = tuple[x, y: int]
  MoveList = array[8, Move]
  MoveIndexes = array[8, int]

const Moves: MoveList = [(2, 1), (1, 2), (-1, 2), (-2, 1), (-2, -1), (-1, -2), (1, -2), (2, -1)]

proc `$`(board: Board): string =
  ## Display the board.
  let size = len($(board.N * board.N)) + 1
  for row in board:
    for val in row:
      stdout.write ($val).align(size)
    echo ""

proc sortedMoves(board: Board; x, y: int): MoveIndexes =
  ## Return the list of moves sorted by count of possible moves.

  var counts: array[8, tuple[value, index: int]]
  for i, d1 in Moves:
    var count = 0
    for d2 in Moves:
      let x2 = x + d1.x + d2.x
      let y2 = y + d1.y + d2.y
      if x2 in 0..<board.N and y2 in 0..<board.N and board[y2][x2] == 0:
        inc count
    counts[i] = (count, i)

  counts.shuffle()  # Shuffle to randomly break ties.
  counts.sort()     # Lexicographic sort.

  for i, count in counts:
    result[i] = count.index


proc knightTour[N: static Positive](start: string): Option[Board[N]] =
  ## Return the knight tour for a board of size N x N and the starting
  ## position "start.
  ## If no solution is found, return "node" else return "some".

  # Initialize the board with the starting position.
  var board: Board[N]
  var startx, starty: int
  startx = ord(start[0]) - ord('a')
  if startx notin 0..<N:
    raise newException(ValueError, "wrong column.")
  if parseInt(start, starty, 1) != start.len - 1 or starty notin 1..N:
    raise newException(ValueError, "wrong line.")
  starty = N - starty
  board[starty][startx] = 1

  type OrderItem = tuple[x, y, idx: int; mi: MoveIndexes]
  var order: array[N * N, OrderItem]
  order[0] = (startx, starty, 0, board.sortedMoves(startx, starty))

  # Search a tour.
  var n = 0
  while n < N * N - 1:
    let x = order[n].x
    let y = order[n].y
    var ok = false

    for i in order[n].idx..7:
      let d = Moves[order[n].mi[i]]
      if x + d.x notin 0..<N  or y + d.y notin 0..<N: continue
      if board[y + d.y][x + d.x] == 0:
        order[n].idx = i + 1
        inc n
        board[y + d.y][x + d.x] = n + 1
        order[n] = (x + d.x, y + d.y, 0, board.sortedMoves(x + d.x, y + d.y))
        ok = true
        break

    if not ok:
      # Failed: backtrack.
      echo "backtrack"
      board[y][x] = 0
      dec n
      if n < 0: return none(Board[N])   # No solution found.

  result = some(board)


proc run[N: static Positive](start: string) =
  ## Run the algorithm and display the result.
  let result = knightTour[N](start)
  echo &"Board size: {N}x{N}, starting position: {start}."
  if result.isSome(): echo result.get()
  else: echo "No solution found.\n"


when isMainModule:

  randomize()

  run[5]("c3")
  #run[5]("c4")  # No solution, so very slow compared to other cases.
  run[8]("b5")
  run[31]("a1")
