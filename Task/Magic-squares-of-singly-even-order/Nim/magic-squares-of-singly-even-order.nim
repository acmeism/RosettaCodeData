import sequtils, strutils

type Square = seq[seq[int]]

func magicSquareOdd(n: Positive): Square =
  ## Build a magic square of odd order.

  assert n >= 3 and (n and 1) != 0, "base must be odd and greater than 2."
  result = newSeqWith(n, newSeq[int](n))

  var
    r = 0
    c = n div 2
    value = 0

  while value < n * n:
    inc value
    result[r][c] = value
    if r == 0:
      if c == n - 1:
        inc r
      else:
        r = n - 1
        inc c
    elif c == n - 1:
      dec r
      c = 0
    elif result[r - 1][c + 1] == 0:
      dec r
      inc c
    else:
      inc r


func magicSquareSinglyEven(n: int): Square =
  ## Build a magic square of singly even order.

  assert n >= 6 and ((n - 2) and 3) == 0, "base must be a positive multiple of 4 plus 2."
  result = newSeqWith(n, newSeq[int](n))

  let
    halfN = n div 2
    subSquareSize = n * n div 4
    subSquare = magicSquareOdd(halfN)

  const QuadrantFactors = [0, 2, 3, 1]

  for r in 0..<n:
    for c in 0..<n:
      let quadrant = r div halfN * 2 + c div halfN
      result[r][c] = subSquare[r mod halfN][c mod halfN] + QuadrantFactors[quadrant] * subSquareSize

  let
    nColsLeft = halfN div 2
    nColsRight = nColsLeft - 1

  for r in 0..<halfN:
    for c in 0..<n:
      if c < nColsLeft or c >= n - nColsRight or (c == nColsLeft and r == nColsLeft):
        if c != 0 or r != nColsLeft:
          swap result[r][c], result[r + halfN][c]


func `$`(square: Square): string =
  ## Return the string representation of a magic square.
  let length = len($(square.len * square.len))
  for row in square:
    result.add row.mapIt(($it).align(length)).join(" ") & '\n'


when isMainModule:
  let n = 6
  echo magicSquareSinglyEven(n)
  echo "Magic constant = ", n * (n * n + 1) div 2
