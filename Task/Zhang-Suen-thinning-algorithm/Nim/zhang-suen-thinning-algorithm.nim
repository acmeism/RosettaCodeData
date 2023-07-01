import math, sequtils, strutils

type
  Bit = 0..1
  BitMatrix = seq[seq[Bit]]     # Two-dimensional array of 0/1.
  Neighbors = array[2..9, Bit]  # Neighbor values.

const Symbols = [Bit(0): '.', Bit(1): '#']


func toBitMatrix(s: openArray[string]): BitMatrix =
  ## Convert an array of 01 strings into a BitMatrix.
  for row in s:
    assert row.allCharsInSet({'0', '1'})
    result.add row.mapIt(Bit(ord(it) - ord('0')))


proc `$`(m: BitMatrix): string =
  ## Return the string representation of a BitMatrix.
  for row in m:
    echo row.mapIt(Symbols[it]).join()

# Templates to allow using double indexing.
template `[]`(m: BitMatrix; i, j: Natural): Bit = m[i][j]
template `[]=`(m: var BitMatrix; i, j: Natural; val: Bit) = m[i][j] = val


func neighbors(m: BitMatrix; i, j: int): Neighbors =
  ## Return the array of neighbors.
  [m[i-1, j], m[i-1, j+1], m[i, j+1], m[i+1, j+1],
   m[i+1, j], m[i+1, j-1], m[i, j-1], m[i-1, j-1]]

func transitions(p: Neighbors): int =
  ## Return the numbers of transitions from P2 to P9.
  for (i, j) in [(2, 3), (3, 4), (4, 5), (5, 6),
                 (6, 7), (7, 8), (8, 9), (9, 2)]:
    result += ord(p[i] == 0 and p[j] == 1)

func thinned(m: BitMatrix): BitMatrix =
  ## Return a thinned version of "m".
  const Pair1 = [2, 8]
  const Pair2 = [4, 6]
  let rowMax = m.high
  let colMax = m[0].high
  result = m

  while true:
    var changed = false

    for step in 1..2:
      let (p1, p2) = if step == 1: (Pair1, Pair2) else: (Pair2, Pair1)
      var m = result
      for i in 1..<rowMax:
        for j in 1..<colMax:

          # Check criteria.
          if m[i, j] == 0:                            # criterion 0.
            continue
          let p = m.neighbors(i, j)
          if sum(p) notin 2..6:                       # criterion 1.
            continue
          if transitions(p) != 1:                     # criterion 2.
            continue
          if p[p1[0]] + p[p2[0]] + p[p2[1]] == 3 or   # criterion 3.
             p[p1[1]] + p[p2[0]] + p[p2[1]] == 3:     # criterion 4.
              continue

          # All criteria satisfied. Store a 0 in "result".
          result[i, j] = 0
          changed = true

    if not changed: break


when isMainModule:

  const Input = ["00000000000000000000000000000000",
                 "01111111110000000111111110000000",
                 "01110001111000001111001111000000",
                 "01110000111000001110000111000000",
                 "01110001111000001110000000000000",
                 "01111111110000001110000000000000",
                 "01110111100000001110000111000000",
                 "01110011110011101111001111011100",
                 "01110001111011100111111110011100",
                 "00000000000000000000000000000000"]

  let input = Input.toBitMatrix()
  let output = input.thinned()
  echo "Input image:"
  echo input
  echo()
  echo "Output image:"
  echo output
