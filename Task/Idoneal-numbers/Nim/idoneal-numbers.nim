import std/[algorithm, math, strformat]

const N = 2000

var isIdoneal: array[1..N, bool]
isIdoneal.fill(true)

for a in 1..sqrt(N / 3).int:
  var p = a * (a + 1)
  for b in (a + 1)..(N div (3 * a)):
    var n = p + (a + b) * (b + 1)
    while n <= N:
      isIdoneal[n] = false
      inc n, a + b
    inc p, a

var idx = 0
for n in 1..N:
  if isIdoneal[n]:
    inc idx
    stdout.write &"{n:>4}"
    stdout.write if idx mod 13 == 0: '\n' else: ' '
echo()
