import algorithm, strutils, sequtils, math, strformat

type
  Matrix = seq[seq[int]]

proc isValidMatrix(m: Matrix): bool =
  return all(m, proc (row: seq[int]): bool = row.len == m[0].len)

proc countSignChanges(container: openarray[int]): int =
  if container.len < 2:
    return 0
  else:
    for i in 1..<container.len:
      if container[i] == -1 * container[i - 1]:
        result += 1

proc `$`(m: Matrix): string =
  for row in m:
    result.add '['
    let length = result.len
    for val in row:
      result.addSep(" ", length)
      result.add ($val).align(2)
    result.add "]\n"

proc `⊗`(a, b: Matrix): Matrix =
  # Modified version of Kronecker product procedure for use with sequtils
  # See here: https://rosettacode.org/wiki/Kronecker_product#Nim
  if a.isValidMatrix and b.isValidMatrix:
    let
      M = a.len
      N = a[0].len
      P = b.len
      Q = b[0].len

    for row in 0..<M * P:
      result.add(newSeq[int](N * Q))

    for i in 0..<M:
      for j in 0..<N:
        for k in 0..<P:
          for l in 0..<Q:
            result[i * P + k][j * Q + l] = a[i][j] * b[k][l]

proc W(k: Positive): Matrix =
  if k == 1:
    return @[@[1, 1], @[1, -1]]
  else:
    return W(1) ⊗ W(k - 1)

for k in 1..5:
  echo &"Walsh matrix of order {k} ({2^k} x {2^k}), Natural order:\n{W(k)}"
  echo &"Walsh matrix of order {k} ({2^k} x {2^k}), Sequency order:\n{W(k).sortedByIt(it.countSignChanges)}"
