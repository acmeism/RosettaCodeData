import random, sequtils, strformat, tables, times

type
  Vector = seq[int]
  Matrix = seq[Vector]
  Cube = seq[Matrix]
  Array16 = array[16, int]
  Array25 = array[25, int]


func newCube(m: Matrix; n: Positive): Cube =
  result.setLen(n)
  for i in 0..<n:
    result[i].setLen(n)
    for j in 0..<n:
      result[i][j].setLen(n)
      let k = if m.len == 0: (i + j) mod n else: m[i][j] - 1
      result[i][j][k] = 1


proc shuffle(c: var Cube) =
  let n = c[0].len
  var proper = true

  var rx, ry, rz: int
  while true:
    rx = rand(n - 1)
    ry = rand(n - 1)
    rz = rand(n - 1)
    if c[rx][ry][rz] == 0: break

  while true:
    var ox, oy, oz = 0

    while ox < n:
      if c[ox][ry][rz] == 1: break
      inc ox
    if not proper and rand(1) == 0:
      inc ox
      while ox < n:
        if c[ox][ry][rz] == 1: break
        inc ox

    while oy < n:
      if c[rx][oy][rz] == 1: break
      inc oy
    if not proper and rand(1) == 0:
      inc oy
      while oy < n:
        if c[rx][oy][rz] == 1: break
        inc oy

    while oz < n:
      if c[rx][ry][oz] == 1: break
      inc oz
    if not proper and rand(1) == 0:
      inc oz
      while oz < n:
        if c[rx][ry][oz] == 1: break
        inc oz

    inc c[rx][ry][rz]
    inc c[rx][oy][oz]
    inc c[ox][ry][oz]
    inc c[ox][oy][rz]

    dec c[rx][ry][oz]
    dec c[rx][oy][rz]
    dec c[ox][ry][rz]
    dec c[ox][oy][oz]

    if c[ox][oy][oz] < 0:
      (rx, ry, rz) = (ox, oy, oz)
      proper = false
    else:
      proper = true
      break


func toMatrix(c: Cube): Matrix =
  let n = c[0].len
  result = newSeqWith(n, newSeq[int](n))
  for i in 0..<n:
    for j in 0..<n:
      for k in 0..<n:
        if c[i][j][k] != 0:
          result[i][j] = k
          break


func toReduced(m: Matrix): Matrix =
  let n = m.len
  result = m

  for j in 0..n-2:
    if result[0][j] != j:
      for k in j+1..<n:
        if result[0][k] == j:
          for i in 0..<n:
            swap result[i][j], result[i][k]
          break

  for i in 1..n-2:
    if result[i][0] != i:
      for k in i+1..<n:
        if result[k][0] == i:
          for j in 0..<n:
            swap result[i][j], result[k][j]
          break


func asArray16(m: Matrix): Array16 =
  var k = 0
  for i in 0..3:
    for j in 0..3:
      result[k] = m[i][j]
      inc k


func asArray25(m: Matrix): Array25 =
  var k = 0
  for i in 0..4:
    for j in 0..4:
      result[k] = m[i][j]
      inc k


proc printArray16(a: Array16) =
  for i in 0..3:
    for j in 0..3:
      let k = i * 4 + j
      stdout.write &"{a[k]+1:2} "   # Back to 1 based.
    echo()
  echo()


proc printMatrix(m: Matrix) =
  let n = m.len
  for i in 0..<n:
    for j in 0..<n:
      stdout.write &"{m[i][j]+1:2} "  # Back to 1 based.
    echo()
  echo()


randomize()

# Part 1.
echo "Part 1: 10_000 latin Squares of order 4 in reduced form:\n"
const From1: Matrix = @[@[1, 2, 3, 4], @[2, 1, 4, 3], @[3, 4, 1, 2], @[4, 3, 2, 1]]
var freqs4: CountTable[Array16]
var c = newCube(From1, 4)
for _ in 1..10_000:
  c.shuffle()
  let m = c.toMatrix
  let rm = m.toReduced
  let a16 = rm.asArray16
  freqs4.inc(a16)

for a, freq in freqs4.pairs:
  printArray16(a)
  echo &"Occurs {freq} times\n"

# Part 2.
echo "\nPart 2: 10_000 latin squares of order 5 in reduced form:"
const From2: Matrix = @[@[1, 2, 3, 4, 5], @[2, 3, 4, 5, 1], @[3, 4, 5, 1, 2],
                        @[4, 5, 1, 2, 3], @[5, 1, 2, 3, 4]]
var freqs5: CountTable[Array25]
c = newCube(From2, 5)
for _ in 1..10_000:
  c.shuffle()
  let m = c.toMatrix
  let rm = m.toReduced
  let a25 = rm.asArray25
  freqs5.inc(a25)

var count = 0
for freq in freqs5.values:
  inc count
  if count > 1: stdout.write ", "
  if (count - 1) mod 8 == 0: echo()
  stdout.write &"{count:2}({freq:3})"
echo '\n'

# Part 3.
echo "\nPart 3: 750 latin squares of order 42, showing the last one:\n"
var m42: Matrix
c = newCube(@[], 42)
for i in 1..750:
  c.shuffle()
  if i == 750:
    m42 = c.toMatrix
printMatrix(m42)

# Part 4.
echo "\nPart 4: 1000 latin squares of order 256:\n"
let start = cpuTime()
c = newCube(@[], 256)
for _ in 1..1000:
  c.shuffle()
echo &"Generated in {cpuTime() - start:.3f} s."
