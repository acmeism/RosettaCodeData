from algorithm import sort
from strutils import align
from sequtils import newSeqWith

type Pos = tuple[x, y: int]

proc `<` (a, b: Pos): bool =
  a.x + a.y < b.x + b.y or
    a.x + a.y == b.x + b.y and (a.x < b.x xor (a.x + a.y) mod 2 == 0)

proc zigzagMatrix(n: int): auto =
  var indices = newSeqOfCap[Pos](n*n)

  for x in 0 ..< n:
    for y in 0 ..< n:
      indices.add((x,y))

  sort(indices)

  result = newSeqWith(n, newSeq[int](n))
  for i, p in indices:
    result[p.x][p.y] = i

proc `$`(m: seq[seq[int]]): string =
  let Width = len($m[0][^1]) + 1
  for r in m:
    for c in r:
      result.add align($c, Width)
    result.add "\n"

echo zigzagMatrix(6)
