import std/[strutils, sugar]

proc isPrime(n: int): bool =
  assert n > 7
  if n mod 2 == 0 or n mod 3 == 0: return false
  var d = 5
  var step = 2
  while d * d <= n:
    if n mod d == 0:
      return false
    inc d, step
    step = 6 - step
  result = true

iterator ascendingPrimes(): int =

  # Yield one digit primes.
  for n in [2, 3, 5, 7]:
    yield n

  # Yield other primes by increasing length and in ascending order.
  type Item = tuple[val, lastDigit: int]
  var items: seq[Item] = collect(for n in 1..9: (n, n))
  for ndigits in 2..9:
    var nextItems: seq[Item]
    for item in items:
      for newDigit in (item.lastDigit + 1)..9:
        let newVal = 10 * item.val + newDigit
        nextItems.add (val: newVal, lastDigit: newDigit)
        if newVal.isPrime():
          yield newVal
    items = move(nextItems)


var rank = 0
for prime in ascendingPrimes():
  inc rank
  stdout.write ($prime).align(8)
  stdout.write if rank mod 10 == 0: '\n' else: ' '
