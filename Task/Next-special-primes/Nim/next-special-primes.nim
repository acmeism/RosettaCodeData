import strutils, sugar

func isPrime(n: Positive): bool =
  if (n and 1) == 0: return n == 2
  var m = 3
  while m * m <= n:
    if n mod m == 0: return false
    inc m, 2
  result = true

iterator nextSpecialPrimes(lim: Positive): int =
  assert lim >= 3
  yield 2
  yield 3
  var last = 3
  var lastGap = 1
  for n in countup(5, lim, 2):
    if not n.isPrime: continue
    if n - last > lastGap:
      lastGap = n - last
      last = n
      yield n

let list = collect(newSeq, for p in nextSpecialPrimes(1050): p)
echo "List of next special primes less than 1050:"
echo list.join(" ")
