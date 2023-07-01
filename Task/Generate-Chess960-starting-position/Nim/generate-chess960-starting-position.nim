import random, strutils

type

  # Chess pieces on first row.
  Pieces {.pure.} = enum
    King = "♔",
    Queen = "♕",
    Rook1 = "♖",
    Rook2 = "♖",
    Bishop1 = "♗",
    Bishop2 = "♗",
    Knight1 = "♘",
    Knight2 = "♘"

  # Position counted from 0.
  Position = range[0..7]

  # Position of pieces.
  Positions = array[Pieces, Position]


func pop[T](s: var set[T]): T =
  ## Remove and return the first element of a set.
  for val in s:
    result = val
    break
  s.excl(result)


proc choose[T](s: var set[T]): T =
  ## Choose randomly a value from a set and remove it from the set.
  result = sample(s)
  s.excl(result)


proc positions(): Positions =
  ## Return a randomly chosen list of piece positions for the first row.

  var pos = {Position.low..Position.high}

  # Set bishops.
  result[Bishop1] = sample([0, 2, 4, 6])    # Black squares.
  result[Bishop2] = sample([1, 3, 5, 7])    # White squares.
  pos = pos - {result[Bishop1], result[Bishop2]}

  # Set queen.
  result[Queen] = pos.choose()

  # Set knights.
  result[Knight1] = pos.choose()
  result[Knight2] = pos.choose()

  # In the remaining three pieces, the king must be between the two rooks.
  result[Rook1] = pos.pop()
  result[King] = pos.pop()
  result[Rook2] = pos.pop()


#———————————————————————————————————————————————————————————————————————————————————————————————————

randomize()

for _ in 1..10:
  var row: array[8, string]
  let pos = positions()
  for piece in Pieces:
    row[pos[piece]] = $piece
  echo row.join("  ")
