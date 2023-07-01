import std/strformat
import integers

iterator cullenNumbers(): (int, Integer) =
  var n = 1
  var p = newInteger(2)
  while true:
    yield (n , n * p + 1)
    inc n
    p = p shl 1

iterator woodallNumbers(): (int, Integer) =
  var n = 1
  var p = newInteger(2)
  while true:
    yield (n , n * p - 1)
    inc n
    p = p shl 1

echo "First 20 Cullen numbers:"
for (n, cn) in cullenNumbers():
  stdout.write &"{cn:>9}"
  if n mod 5 == 0: echo()
  if n == 20: break

echo "\nFirst 20 Woodall numbers:"
for (n, wn) in woodallNumbers():
  stdout.write &"{wn:>9}"
  if n mod 5 == 0: echo()
  if n == 20: break

echo "\nFirst 5 Cullen primes (in terms of n):"
var count = 0
for (n, cn) in cullenNumbers():
  if cn.isPrime:
    stdout.write ' ', n
    inc count
    if count == 5: break
echo()

echo "\nFirst 12 Woodall primes (in terms of n):"
count = 0
for (n, wn) in woodallNumbers():
  if wn.isPrime:
    stdout.write ' ', n
    inc count
    if count == 12: break
echo()
