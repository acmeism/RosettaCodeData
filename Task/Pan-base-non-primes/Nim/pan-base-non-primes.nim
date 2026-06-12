import std/strformat

func isPrime(n: int64): bool =
  const Wheel = [4, 2, 4, 2, 4, 6, 2, 6]
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  if n mod 5 == 0: return n == 5
  var p = 7
  while true:
    for w in Wheel:
      if p * p > n: return true
      if n mod p == 0: return false
      inc p, w

func digits(n: int64): seq[byte] =
  ## Compute the digits of n in base 10, least significant digit first.
  var n = n
  while n != 0:
    result.add byte(n mod 10)
    n = n div 10

func fromDigits(a: seq[byte]; base: Positive): int64 =
  ## Convert digits in the given base to a number (least significant digit first).
  for i in countdown(a.high, 0):
    result = result * base + a[i].int

func isPanBaseNonPrime(n: int64): bool =
  if n < 10: return not n.isPrime()
  if n > 10 and n mod 10 == 0: return true
  let d = n.digits
  let maxDigit = max(d).int
  for base in (maxDigit + 1)..n:
    if d.fromDigits(base).isPrime():
      return false
  result = true


echo "First 50 prime pan-base composites:"
var count = 0;
var n = 2
while count < 50:
  if n.isPanBaseNonPrime():
    inc count
    stdout.write &"{n:3}", if count mod 10 == 0: '\n' else: ' '
  inc n

echo "\nFirst 20 odd prime pan-base composites:"
count = 0
n = 3
while count < 20:
  if n.isPanBaseNonPrime():
    inc count
    stdout.write &"{n:3}", if count mod 10 == 0: '\n' else: ' '
  inc n, 2

const Limit = 10_000
var odd = 0
count = 0
for n in 2..Limit:
  if n.isPanBaseNonPrime():
    inc count
    if (n and 1) == 1:
      inc odd
echo &"\nCount of pan-base composites up to and including {Limit}: {count}"
let percent = 100 * odd / count
echo &"Percent odd  up to and including {Limit}: {percent:.6f}"
echo &"Percent even up to and including {Limit}: {100 - percent:.6f}"
