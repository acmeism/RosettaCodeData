import math, strutils

proc divisors(n: Positive): seq[int] =
  for d in 1..sqrt(n.toFloat).int:
    if n mod d == 0:
      result.add d
      if n div d != d:
        result.add n div d

for n in 1..100:
  stdout.write ($sum(n.divisors)).align(3), if (n + 1) mod 10 == 0: '\n' else: ' '
