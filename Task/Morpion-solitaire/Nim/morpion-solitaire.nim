import os, random, sequtils
import ncurses

const
  LineLength = 5
  Disjoint = 0

type
  State {.pure.} = enum Blank, Occupied, DirNS, DirEW, DirNESW, DirNWSE, NewlyAdded, Current
  States = set[State]
  Board = seq[seq[States]]
  Move = tuple[m, s, seqnum, x, y: int]

const Ofs = [(0, 1, DirNS), (1, 0, DirEW), (1, -1, DirNESW), (1, 1, DirNWSE)]


func set(board: var Board; value: State; x0, y0, x1, y1: int) =
  for i in y0..y1:
    for j in x0..x1:
      board[i][j] = {value}


func initBoard(): Board =
  let height, width = 3 * (LineLength - 1)
  result = newSeqWith(height, newSeq[States](width))
  result.set(Occupied, LineLength - 1, 1, 2 * LineLength - 3, height - 2)
  result.set(Occupied, 1, LineLength - 1, width - 2, 2 * LineLength - 3)
  result.set(Blank, LineLength, 2, 2 * LineLength - 4, height - 3)
  result.set(Blank, 2, LineLength, width - 3, 2 * LineLength - 4)


func expand(board: var Board; dw, dh: int) =

  # -1: expand low index end, +1: expand high index end.
  let
    height = board.len
    width = board[0].len
    nw = width + ord(dw != 0)
    nh = height + ord(dh != 0)

  var nboard = newSeqWith(nh, newSeq[States](nw))
  let dw = -ord(dw < 0)
  let dh = -ord(dh < 0)

  for i in 0..<nh:
    if i + dh notin 0..<height: continue
    for j in 0..<nw:
      if j + dw notin 0..<width: continue
      nboard[i][j] = board[i + dh][j + dw]

  board = move(nboard)


proc show(board: Board) =
  for i, row in board:
    for j, cell in row:
      let str = if Current in cell: "X "
                elif NewlyAdded in cell: "0 "
                elif Occupied in cell: "+ "
                else: "  "
      mvprintw(cint(i + 1), cint(j + 2), str)
  refresh()


proc testPosition(board: Board; y, x: int; rec: var Move) =
  let height = board.len
  let width = board[0].len
  if Occupied in board[y][x]: return

  for m, (dx, dy, dir) in Ofs:      # 4 directions.
    for s in (1 - LineLength)..0:   # offset line.
      var k = -1
      while k < LineLength:
        inc k
        if s + k == 0: continue
        let xx = x + dx * (s + k)
        let yy = y + dy * (s + k)
        if xx < 0 or xx >= width or yy < 0 or yy >= height: break
        if Occupied notin board[yy][xx]: break  # No piece at position.
        if dir in board[yy][xx]: break          # This direction taken.
      if k != LineLength: continue

      # Position ok.
      # Rand to even each option chance of being picked.
      if rand(rec.seqnum) == 0:
        rec.m = m; rec.s = s; rec.x = x; rec.y = y
      inc rec.seqnum


proc addPiece(board: var Board; rec: Move) =
  let (dx, dy, dir) = Ofs[rec.m]
  board[rec.y][rec.x] = board[rec.y][rec.x] + {Current, Occupied}
  for k in 0..<LineLength:
    let xx = rec.x + dx * (k + rec.s)
    let yy = rec.y + dy * (k + rec.s)
    board[yy][xx].incl NewlyAdded
    if k >= Disjoint or k < LineLength - Disjoint:
      board[yy][xx].incl dir


proc nextMove(board: var Board): bool {.discardable.} =
  var rec: Move
  let maxi = board.high
  let maxj = board[0].high

  # Wipe last iteration new line markers.
  for row in board.mitems:
    for cell in row.mitems:
      cell = cell - {NewlyAdded, Current}

  # Randomly pick one of next legal move.
  for i in 0..maxi:
    for j in 0..maxj:
      board.testPosition(i, j, rec)

  # Didn't find any move, game over.
  if rec.seqnum == 0: return false

  board.addPiece(rec)

  rec.x = if rec.x == maxj: 1
          elif rec.x != 0: 0
          else: -1
  rec.y = if rec.y == maxi: 1
          elif rec.y != 0: 0
          else: -1

  if rec.x != 0 or rec.y != 0: board.expand(rec.x, rec.y)
  result = true


proc play() =
  randomize()
  var board = initBoard()
  var waitKey = true
  let win {.used.} = initscr()
  noecho()
  cbreak()

  var move = 0
  while true:
    mvprintw(0, 0, "Move %d", move)
    inc move
    board.show()
    if not board.nextMove():
      board.nextMove()
      board.show()
      break
    if not waitKey: sleep(100)
    let ch = getch()
    if ch == ord(' '):
      waitKey = not waitKey
      if waitKey: timeout(-1)
      else: timeout(0)
    elif ch == ord('q'):
      break

  timeout(-1)
  getch()
  nocbreak()
  onecho()
  endwin()

play()
