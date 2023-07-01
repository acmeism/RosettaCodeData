import math, strutils

func largestProperDivisor(n: Positive): int =
  for d in 2..sqrt(float(n)).int:
    if n mod d == 0: return n div d
  result = 1

for n in 1..100:
  stdout.write ($n.largestProperDivisor).align(2), if n mod 10 == 0: '\n' else: ' '
