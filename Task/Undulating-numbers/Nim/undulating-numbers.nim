import std/[algorithm, math, strutils]

func isPrime(n: Natural): bool =
  ## Return true if "n" is prime.
  if n < 2: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var k = 5
  var delta = 2
  while k * k <= n:
    if n mod k == 0: return false
    inc k, delta
    delta = 6 - delta
  result = true

func toBase(n, base: Natural): string =
  ## Return the string representation of "n" in given base.
  assert base in 2..10
  var n = n
  var s: seq[int]
  if n == 0: return "0"
  while n != 0:
    s.add n mod base
    n = n div base
  result = reversed(s).join()

func buildNumber (a, b, n, base: int): int =
  ## Build an undulating number of length "n" in
  ## given base, returning its value in base 10.
  var digits = [a, b]
  var idx = 0
  for i in 1..n:
    result = base * result + digits[idx]
    idx = 1 - idx

iterator undulatingNumbers(nStart, nEnd: Positive; base = 10): int =
  ## Yield the successive undulating numbers in given base (expressed in
  ## base 10), starting with "nStart" digits and ending with "nEnd" digits.
  assert nStart >= 3, "need at least three digits."
  var n = nStart
  while n <= nEnd :
    for a in 1..<base:
      for b in 0..<base:
        if b == a: continue
        yield buildNumber(a, b, n, base)
    inc n

### Task - Part 1 ###

echo "Three digits undulating numbers in base 10:"
var count = 0
for unum in undulatingNumbers(3, 3):
  inc count
  stdout.write unum
  stdout.write if count mod 9 == 0: '\n' else: ' '

### Task - Part 2 ###

echo "\nFour digits undulating numbers in base 10:"
count = 0
for unum in undulatingNumbers(4, 4):
  inc count
  stdout.write unum
  stdout.write if count mod 9 == 0: '\n' else: ' '

### Task - Part 3 ###

echo "\nThree digits undulating numbers in base 10 which are primes:"
count = 0
for unum in undulatingNumbers(3, 3):
  if unum.isPrime:
    inc count
    stdout.write unum
    stdout.write if count == 15: '\n' else: ' '

### Task - Part 4 ###

count = 0
for unum in undulatingNumbers(3, 10):
  inc count
  if count == 600:
    echo "\nThe 600th undulating number in base 10 is ", unum
    break

### Task - Part 5 ###

const N = 2^53
count = (D10 - 3) * 81    # For each number of digits, there are 9 × 9 undulating numbers.
count = (D10 - 3) * 81
var last: int
for unum in undulatingNumbers(D10, D10):
  if unum < N:
    inc count
    last = unum
  else: break
echo "\nNumber of undulating numbers in base 10 less than 2^53: ", count
echo "The last undulating number in base 10 less than 2^53 is ", last

### Bonus - Part 1 ###
echo "\nThree digits undulating numbers in base 7 (shown in base 10):"
count = 0
for unum in undulatingNumbers(3, 3, 7):
  inc count
  stdout.write align($unum, 3)
  stdout.write if count mod 9 == 0: '\n' else: ' '

### Bonus - Part 2 ###
echo "\nFour digits undulating numbers in base 7 (shown in base 10):"
count = 0
for unum in undulatingNumbers(4, 4, 7):
  inc count
  stdout.write align($unum, 4)
  stdout.write if count mod 9 == 0: '\n' else: ' '

### Bonus - Part 3 ###

echo "\nThree digits undulating numbers in base 7 which are primes:"
count = 0
for unum in undulatingNumbers(3, 3, 7):
  if unum.isPrime:
    inc count
    stdout.write unum
    stdout.write if count == 6: '\n' else: ' '

### Bonus - Part 4 ###

count = 0
for unum in undulatingNumbers(3, 19, 7):
  inc count
  if count == 600:
    echo "\nThe 600th undulating number in base 7 is ", unum.toBase(7)
    echo "which is ", unum, " in base 10."
    break

### Bonus - Part 5 ###

const D7 = int(ln(N.toFloat) / ln(7.0)) + 1
count = (D7 - 3) * 36   # For each number of digits, there are 6 × 6 undulating numbers.
last = 0
for unum in undulatingNumbers(D7, D7, 7):
  if unum < N:
    inc count
    last = unum
  else: break
echo "\nNumber of undulating numbers in base 7 less than 2^53: ", count
echo "The last undulating number in base 7 less than 2^53 is ", last.toBase(7)
echo "which is ", last, " in base 10."
