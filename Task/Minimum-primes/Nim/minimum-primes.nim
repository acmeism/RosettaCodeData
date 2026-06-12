const
  Numbers1 = [ 5, 45, 23, 21, 67]
  Numbers2 = [43, 22, 78, 46, 38]
  Numbers3 = [ 9, 98, 12, 54, 53]

var numbers: array[0..Numbers1.high, int]

template isEven(n: int): bool = (n and 1) == 0

func isPrime(n: Positive): bool =
  if n < 2: return false
  if n.isEven: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true

func minPrime(n: int): int =
  if n == 2: return 2
  result = if n.isEven: n + 1 else: n
  while not result.isPrime():
    inc result, 2

for i in 0..numbers.high:
  let m = max(max(Numbers1[i], Numbers2[i]), Numbers3[i])
  numbers[i] = minPrime(m)

echo numbers
