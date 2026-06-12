import strutils

const N = 999

func isPrime(n: Positive): bool =
  if (n and 1) == 0: return n == 2
  var m = 3
  while m * m <= n:
    if n mod m == 0: return false
    inc m, 2
  result = true

func reversed(n: Positive): int =
  var n = n.int
  while n != 0:
    result = 10 * result + n mod 10
    n = n div 10

func isPalindromic(n: Positive): bool =
  n == reversed(n)

var result: seq[int]
for n in 2..N:
  if n.isPrime and n.isPalindromic:
    result.add n

for i, n in result:
  stdout.write ($n).align(3)
  stdout.write if (i + 1) mod 10 == 0: '\n' else: ' '
