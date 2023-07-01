import random

type

  Piece {.pure.} = enum
    None
    WhiteBishop = ('B', "♗")
    WhiteKing = ('K', "♔")
    WhiteKnight = ('N', "♘")
    WhitePawn = ('P', "♙")
    WhiteQueen = ('Q', "♕")
    WhiteRook = ('R', "♖")
    BlackBishop = ('b', "♝")
    BlackKing = ('k', "♚")
    BlackKnight = ('n', "♞")
    BlackPawn = ('p', "♟")
    BlackQueen = ('q', "♛")
    BlackRook = ('r', "♜")

  Color {.pure.} = enum White, Black

  Grid = array[8, array[8, Piece]]

const
  # White pieces except king and pawns.
  WhitePieces = [WhiteQueen, WhiteRook, WhiteRook, WhiteBishop,
                 WhiteBishop, WhiteKnight, WhiteKnight]

  # Black pieces except king and pawns.
  BlackPieces = [BlackQueen, BlackRook, BlackRook, BlackBishop,
                 BlackBishop, BlackKnight, BlackKnight]

proc placeKings(grid: var Grid) =
  while true:
    let r1 = rand(7)
    let c1 = rand(7)
    let r2 = rand(7)
    let c2 = rand(7)
    if r1 != r2 and abs(r1 - r2) > 1 and abs(c1 - c2) > 1:
      grid[r1][c1] = WhiteKing
      grid[r2][c2] = BlackKing
      break

proc placePawns(grid: var Grid; color: Color) =
  let piece = if color == White: WhitePawn else: BlackPawn
  let numToPlace = rand(8)
  for n in 0..<numToPlace:
    var r, c: int
    while true:
      r = rand(7)
      c = rand(7)
      if grid[r][c] == None and r notin {0, 7}: break
    grid[r][c] = piece


proc placePieces(grid: var Grid; color: Color) =
  var pieces = if color == White: WhitePieces else: BlackPieces
  pieces.shuffle()
  let numToPlace = rand(7)
  for n in 0..<numToPlace:
    var r, c: int
    while true:
      r = rand(7)
      c = rand(7)
      if grid[r][c] == None: break
    grid[r][c] = pieces[n]


proc toFen(grid: Grid): string =
  var countEmpty = 0
  for r in 0..7:
    for c in 0..7:
      let piece = grid[r][c]
      if piece == None:
        stdout.write " . "
        inc countEmpty
      else:
        stdout.write ' ' & $piece & ' '
        if countEmpty > 0:
          result.add $countEmpty
          countEmpty = 0
        result.add chr(ord(piece))

    if countEmpty > 0:
      result.add $countEmpty
      countEmpty = 0

    result.add '/'
    echo ""

  result.add " w - - 0 1"


proc createFen(): string =
  var grid: Grid
  grid.placeKings()
  grid.placePawns(White)
  grid.placePawns(Black)
  grid.placePieces(White)
  grid.placePieces(Black)
  result = grid.toFen()


randomize()
echo createFen()
