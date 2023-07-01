import math, strutils

const N = 499

# Sieve of Erathostenes.
var composite: array[2..N, bool]  # Initialized to false, ie. prime.

for n in 2..sqrt(N.toFloat).int:
  if not composite[n]:
    for k in countup(n * n, N, n):
      composite[k] = true


func digitSum(n: Positive): Natural =
  ## Compute sum of digits.
  var n = n.int
  while n != 0:
    result += n mod 10
    n = n div 10


echo "Additive primes less than 500:"
var count = 0
for n in 2..N:
  if not composite[n] and not composite[digitSum(n)]:
    inc count
    stdout.write ($n).align(3)
    stdout.write if count mod 10 == 0: '\n' else: ' '
echo()

echo "\nNumber of additive primes found: ", count
