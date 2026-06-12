import strutils

iterator digits(n: Positive): int =
  var n = n.int
  while n != 0:
    yield n mod 10
    n = n div 10

var result: seq[int]
for n in 1..1000:
  block check:
    var m = 1
    for d in n.digits:
      if d == 0 or n mod d != 0: break check
      m *= d
    if n mod m != 0: result.add n

echo "Found ", result.len, " matching numbers."
for i, n in result:
  stdout.write ($n).align(3), if (i + 1) mod 9 == 0: '\n' else: ' '
