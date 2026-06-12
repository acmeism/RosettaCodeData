import strutils

func isPrime(n: Positive): bool =
  if n == 1: return false
  if n mod 2 == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  return true

func digitSum(n, b: Natural): int =
  var n = n
  while n != 0:
    result += n mod b
    n = n div b

var count = 0
for n in 2..<200:
  if digitSum(n, 2).isPrime and digitSum(n, 3).isPrime:
    inc count
    stdout.write ($n).align(3), if count mod 16 == 0: '\n' else: ' '
echo()
echo "Found ", count, " numbers."
