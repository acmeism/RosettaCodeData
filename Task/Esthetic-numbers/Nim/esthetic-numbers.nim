import strformat

func isEsthetic(n, b: int64): bool =
  if n == 0: return false
  var i = n mod b
  var n = n div b
  while n > 0:
    let j = n mod b
    if abs(i - j) != 1:
      return false
    n = n div b
    i = j
  result = true


proc listEsths(n1, n2, m1, m2: int64; perLine: int; all: bool) =
  var esths: seq[int64]

  func dfs(n, m, i: int64) =
    if i in n..m: esths.add i
    if i == 0 or i > m: return
    let d = i mod 10
    let i1 = i * 10 + d - 1
    let i2 = i1 + 2
    case d
    of 0:
      dfs(n, m, i2)
    of 9:
      dfs(n, m, i1)
    else:
      dfs(n, m, i1)
      dfs(n, m, i2)

  for i in 0..9:
    dfs(n2, m2, i)

  echo &"Base 10: {esths.len} esthetic numbers between {n1} and {m1}:"
  if all:
    for i, esth in esths:
      stdout.write esth
      stdout.write if (i + 1) mod perLine == 0: '\n' else: ' '
    echo()
  else:
    for i in 0..<perLine:
      stdout.write esths[i], ' '
    echo "\n............"
    for i in esths.len - perLine .. esths.high:
      stdout.write esths[i], ' '
    echo()
  echo()


proc toBase(n, b: int64): string =
  const Digits = ['0', '1', '2', '3', '4', '5', '6', '7',
                  '8', '9', 'a', 'b', 'c', 'd', 'e', 'f']

  if n == 0: return "0"
  var n = n
  while n > 0:
    result.add Digits[n mod b]
    n = n div b
  for i in 0..<(result.len div 2):
    swap result[i], result[result.high - i]


for b in 2..16:
  echo &"Base {b}: {4 * b}th to {6 * b}th esthetic numbers:"
  var n = 1i64
  var c = 0i64
  while c < 6 * b:
    if n.isEsthetic(b):
      inc c
      if c >= 4 * b: stdout.write n.toBase(b), ' '
    inc n
  echo '\n'

# The following all use the obvious range limitations for the numbers in question.
listEsths(1000, 1010, 9999, 9898, 16, true)
listEsths(100_000_000, 101_010_101, 130_000_000, 123_456_789, 9, true)
listEsths(100_000_000_000, 101_010_101_010, 130_000_000_000, 123_456_789_898, 7, false)
listEsths(100_000_000_000_000, 101_010_101_010_101, 130_000_000_000, 123_456_789_898_989, 5, false)
listEsths(100_000_000_000_000_000, 101_010_101_010_101_010, 130_000_000_000_000_000, 123_456_789_898_989_898, 4, false)
