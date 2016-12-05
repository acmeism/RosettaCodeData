import algorithm, strutils

type Pos = tuple[x, y: int]

template newSeqWith(len: int, init: expr): expr =
  var result {.gensym.} = newSeq[type(init)](len)
  for i in 0 .. <len:
    result[i] = init
  result

proc `$`(m: seq[seq[int]]): string =
  result = ""
  for r in m:
    for c in r:
      result.add align($c, 2) & " "
    result.add "\n"

proc zigzagMatrix(n): auto =
  result = newSeqWith(n, newSeq[int](n))

  var indices = newSeq[Pos]()

  for x in 0 .. <n:
    for y in 0 .. <n:
      indices.add((x,y))

  sort(indices, proc(a, b: Pos): int =
    result = a.x + a.y - b.x - b.y
    if result == 0: result =
      (if (a.x + a.y) mod 2 == 0: a.y else: -a.y) -
      (if (b.x + b.y) mod 2 == 0: b.y else: -b.y))

  for i, p in indices:
    result[p.x][p.y] = i

echo zigzagMatrix(6)
