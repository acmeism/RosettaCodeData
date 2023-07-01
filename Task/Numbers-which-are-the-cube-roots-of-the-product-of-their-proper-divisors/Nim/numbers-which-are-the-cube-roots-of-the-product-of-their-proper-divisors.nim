import std/strformat

iterator properDivisors(n: Positive): Positive =
  ## Yield the proper divisors, except 1.
  var d = 2
  while d * d <= n:
    if n mod d == 0:
      yield d
      let q = n div d
      if q != d: yield q
    inc d

iterator a111398(): (int, int) =
  ## Yield the successive elements of the OEIS A111398 sequence.
  yield (1, 1)
  var idx = 1
  var n = 1
  while true:
    inc n
    var p = 1
    block Check:
      let n3 = n * n * n
      for d in properDivisors(n):
        p *= d
        if p > n3: break Check  # Two large: try next value.
      if n3 == p:
        inc idx
        yield (idx, n)

echo "First 50 numbers which are the cube roots of the products of their proper divisors:"
for (i, n) in a111398():
  if i <= 50:
    stdout.write &"{n:>3}"
    stdout.write if i mod 10 == 0: '\n' else: ' '
    stdout.flushFile
  elif i in [500, 5000, 50000]:
    echo &"{i:>5}th: {n:>6}"
    if i == 50000: break
