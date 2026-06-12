import strutils

func reversed(n: Positive): int =
  var n = n.int
  while n != 0:
    result = 10 * result + n mod 10
    n = n div 10

func divisors(n: Positive): seq[int] =
  result = @[1, n]
  var d = 2
  while d * d <= n:
    if n mod d == 0:
      result.add d
      if d * d != n:
        result.add n div d
    inc d

var count = 0
for n in 1..<200:
  let revn = reversed(n)
  block check:
    for d in divisors(n):
      if revn mod reversed(d) != 0:
        break check
    inc count
    stdout.write ($n).align(3), if count mod 12 == 0: '\n' else: ' '
