import sequtils, strformat, strutils, sugar, tables, unicode

type Piece {.pure.} = enum Rook = "R", Knight = "N", Bishop = "B", Queen = "Q", King = "K"

const
  GlypthToPieces = {"♜": Rook, "♞": Knight, "♝": Bishop, "♛": Queen, "♚": King,
                    "♖": Rook, "♘": Knight, "♗": Bishop, "♕": Queen, "♔": King}.toTable
  Names = [Rook: "rook", Knight: "knight", Bishop: "bishop", Queen: "queen", King: "king"]
  NTable = {[0, 1]: 0, [0, 2]: 1, [0, 3]: 2, [0, 4]: 3, [1, 2]: 4,
            [1, 3]: 5, [1, 4]: 6, [2, 3]: 7, [2, 4]: 8, [3, 4]: 9}.toTable

func toPieces(glyphs: string): seq[Piece] =
  collect(newSeq, for glyph in glyphs.runes: GlypthToPieces[glyph.toUTF8])

func isEven(n: int): bool = (n and 1) == 0

func positions(pieces: seq[Piece]; piece: Piece): array[2, int] =
  var idx = 0
  for i, p in pieces:
    if p == piece:
      result[idx] = i
      inc idx

func spid(glyphs: string): int =

  let pieces = glyphs.toPieces()

  # Check for errors.
  if pieces.len != 8:
    raise newException(ValueError, "there must be exactly 8 pieces.")
  for piece in [King, Queen]:
    if pieces.count(piece) != 1:
      raise newException(ValueError, &"there must be one {Names[piece]}.")
  for piece in [Rook, Knight, Bishop]:
    if pieces.count(piece) != 2:
      raise newException(ValueError, &"there must be two {Names[piece]}s.")
  let r = pieces.positions(Rook)
  let k = pieces.find(King)
  if k < r[0] or k > r[1]:
    raise newException(ValueError, "the king must be between the rooks.")
  var b = pieces.positions(Bishop)
  if isEven(b[1] - b[0]):
    raise newException(ValueError, "the bishops must be on opposite color squares.")

  # Compute SP_ID.
  let piecesN = pieces.filterIt(it notin [Queen, Bishop])
  let n = NTable[piecesN.positions(Knight)]

  let piecesQ = pieces.filterIt(it != Bishop)
  let q = piecesQ.find(Queen)

  if b[1].isEven: swap b[0], b[1]
  let d = [0, 2, 4, 6].find(b[0])
  let l = [1, 3, 5, 7].find(b[1])

  result = 96 * n + 16 * q + 4 * d + l


for glyphs in ["♕♘♖♗♗♘♔♖", "♖♘♗♕♔♗♘♖", "♖♕♘♗♗♔♖♘", "♖♘♕♗♗♔♖♘"]:
  echo &"{glyphs} or {glyphs.toPieces().join()} has SP-ID of {glyphs.spid()}"
