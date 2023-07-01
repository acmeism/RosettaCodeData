import algorithm, math, sequtils, strformat

type

  # Row managed as a sequence of ints with base index 1.
  Row = object
    value: seq[int]

  # Matrix managed as a sequence of rows with base index 1.
  Matrix = object
    value: seq[Row]

func newRow(n: Natural = 0): Row =
  ## Create a new row of length "n".
  Row(value: newSeq[int](n))

# Create a new matrix of length "n" containing rows of length "p".
func newMatrix(n, p: Natural = 0): Matrix = Matrix(value: newSeqWith(n, newRow(p)))

# Functions for rows.
func `[]`(r: var Row; i: int): var int = r.value[i - 1]
func `[]=`(r: var Row; i, n: int) = r.value[i - 1] = n
func sort(r: var Row; low, high: Positive) =
  r.value.toOpenArray(low - 1, high - 1).sort()
func `$`(r: Row): string = ($r.value)[1..^1]

# Functions for matrices.
func `[]`(m: Matrix; i: int): Row = m.value[i - 1]
func `[]`(m: var Matrix; i: int): var Row = m.value[i - 1]
func `[]=`(m: var Matrix; i: int; r: Row) = m.value[i - 1] = r
func high(m: Matrix): Natural = m.value.len
func add(m: var Matrix; r: Row) = m.value.add r
func `$`(m: Matrix): string =
  for row in m.value: result.add $row & '\n'


func dList(n, start: Positive): Matrix =
  ## Generate derangements of first 'n' numbers, with 'start' in first place.

  var a = Row(value: toSeq(1..n))

  swap a[1], a[start]
  a.sort(2, n)
  let first = a[2]
  var r: Matrix

  func recurse(last: int) =
    ## Recursive closure permutes a[2..^1].
    if last == first:
      # Bottom of recursion. You get here once for each permutation.
      # Test if permutation is deranged.
      for i in 2..n:
        if a[i] == i: return  # No: ignore it.
      r.add a
      return
    for i in countdown(last, 2):
      swap a[i], a[last]
      recurse(last - 1)
      swap a[i], a[last]

  recurse(n)
  result = r


proc reducedLatinSquares(n: Positive; print: bool): int =

  if n == 1:
    if print: echo [1]
    return 1

  var rlatin = newMatrix(n, n)
  # Initialize first row.
  for i in 1..n: rlatin[1][i] = i

  var count = 0

  proc recurse(i: int) =
    let rows = dList(n, i)
    for r in 1..rows.high:
      block inner:
        rlatin[i] = rows[r]
        for k in 1..<i:
          for j in 2..n:
            if rlatin[k][j] == rlatin[i][j]:
              if r < rows.high: break inner
              if i > 2: return
        if i < n:
          recurse(i + 1)
        else:
          inc count
          if print: echo rlatin

  # Remaining rows.
  recurse(2)
  result = count


when isMainModule:

  echo "The four reduced latin squares of order 4 are:"
  discard reducedLatinSquares(4, true)

  echo "The size of the set of reduced latin squares for the following orders"
  echo "and hence the total number of latin squares of these orders are:"
  for n in 1..6:
    let size = reducedLatinSquares(n, false)
    let f = fac(n - 1)^2 * n * size
    echo &"Order {n}: Size {size:<4} x {n}! x {n - 1}! => Total {f}"
