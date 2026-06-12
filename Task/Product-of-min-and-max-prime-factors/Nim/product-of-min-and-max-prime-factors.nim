import std/strformat

func primeFactors(n: Positive): seq[Natural] =
  if n == 1: return @[1]
  var n = n
  var d = 2
  while d * d <= n:
    if n mod d == 0:
      result.add d
      while n mod d == 0:
        n = n div d
    inc d
  if n != 1: result.add n

for n in 1..100:
  let pf = n.primeFactors
  stdout.write &"{pf[0] * pf[^1]:4}"
  stdout.write if n mod 10 == 0: '\n' else: ' '
