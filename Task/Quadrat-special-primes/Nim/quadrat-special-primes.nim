import math, strutils, sugar

func isPrime(n: Natural): bool =
  if n < 2: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

const
  Max = 16_000
  Squares = collect(newSeq):
              for n in countup(2, sqrt(Max.float).int, 2): n * n

iterator quadraPrimes(lim: Positive): int =
  assert lim >= 3
  yield 2
  yield 3
  var n = 3
  block mainloop:
    while true:
      for square in Squares:
        let next = n + square
        if next > lim: break mainloop
        if next.isPrime:
          n = next
          yield n
          break

echo "Quadrat special primes < 16000:"
var count = 0
for qp in quadraPrimes(Max):
  inc count
  stdout.write ($qp).align(5), if count mod 7 == 0: '\n' else: ' '
