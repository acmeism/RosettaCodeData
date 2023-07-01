import math, sequtils, strutils

type SquareMatrix = seq[seq[Natural]]

func newSquareMatrix(n: Positive): SquareMatrix =
  ## Create a square matrix.
  newSeqWith(n, newSeq[Natural](n))

func pascalUpperTriangular(n: Positive): SquareMatrix =
  ## Create an upper Pascal matrix.
  result = newSquareMatrix(n)
  for i in 0..<n:
    for j in i..<n:
      result[i][j] = binom(j, i)

func pascalLowerTriangular(n: Positive): SquareMatrix =
  ## Create a lower Pascal matrix.
  result = newSquareMatrix(n)
  for i in 0..<n:
    for j in i..<n:
      result[j][i] = binom(j, i)

func pascalSymmetric(n: Positive): SquareMatrix =
  ## Create a symmetric Pascal matrix.
  result = newSquareMatrix(n)
  for i in 0..<n:
    for j in 0..<n:
      result[i][j] = binom(i + j, i)

proc print(m: SquareMatrix) =
  ## Print a square matrix.
  let matMax = max(m.mapIt(max(it)))
  let length = ($matMax).len
  for i in 0..m.high:
    echo "| ", m[i].mapIt(($it).align(length)).join(" "), " |"

echo "Upper:"
print pascalUpperTriangular(5)
echo "\nLower:"
print pascalLowerTriangular(5)
echo "\nSymmetric:"
print pascalSymmetric(5)
