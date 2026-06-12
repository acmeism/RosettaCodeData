import std/strformat

func isPrime(n: Natural): bool =
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

echo " n  m  prime"
for n in 1..45:
  var m = 0
  var term = n
  while true:
    if isPrime(term + 1):
      echo &"{n:2}  {m}  {term + 1:5}"
      break
    inc m
    term *= 2
