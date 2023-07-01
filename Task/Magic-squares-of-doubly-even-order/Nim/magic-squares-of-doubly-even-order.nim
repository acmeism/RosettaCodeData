import bitops, sequtils, strutils

type Square = seq[seq[int]]

func magicSquareDoublyEven(n: int): Square =
  ## Build a magic square of doubly even order.

  assert n >= 4 and (n and 3) == 0, "base must be a positive multiple of 4."
  result = newSeqWith(n, newSeq[int](n))

  const bits = 0b1001_0110_0110_1001  # Pattern of count-up vs count-down zones.
  let size = n * n
  let mult = n div 4                  # How many multiples of 4.

  var i = 0
  for r in 0..<n:
    for c in 0..<n:
      let bitPos = c div mult + r div mult * 4
      result[r][c] = if bits.testBit(bitPos): i + 1 else: size - i
      inc i


func `$`(square: Square): string =
  ## Return the string representation of a magic square.
  let length = len($(square.len * square.len))
  for row in square:
    result.add row.mapIt(($it).align(length)).join(" ") & '\n'


when isMainModule:
  let n = 8
  echo magicSquareDoublyEven(n)
  echo "Magic constant = ", n * (n * n + 1) div 2
