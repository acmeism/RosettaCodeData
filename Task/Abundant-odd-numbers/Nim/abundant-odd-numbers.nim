from math import sqrt
import strformat

#---------------------------------------------------------------------------------------------------

proc sumProperDivisors(n: int): int =
  ## Compute the sum of proper divisors.
  ## "n" is supposed to be odd.
  result = 1
  for d in countup(3, sqrt(n.toFloat).int, 2):
    if n mod d == 0:
      inc result, d
      if n div d != d:
        inc result, n div d

#---------------------------------------------------------------------------------------------------

iterator oddAbundant(start: int): tuple[n, s: int] =
  ## Yield the odd abundant numbers and the sum of their proper
  ## divisors greater or equal to "start".
  var n = start + (start and 1 xor 1)   # Start with an odd number.
  while true:
    let s = n.sumProperDivisors()
    if s > n:
      yield (n, s)
    inc n, 2

#---------------------------------------------------------------------------------------------------

echo "List of 25 first odd abundant numbers."
echo "Rank  Number  Proper divisors sum"
echo "----  -----   -------------------"
var rank = 0
for (n, s) in oddAbundant(1):
  inc rank
  echo fmt"{rank:2}:   {n:5}   {s:5}"
  if rank == 25:
    break

echo ""
rank = 0
for (n, s) in oddAbundant(1):
  inc rank
  if rank == 1000:
    echo fmt"The 1000th odd abundant number is {n}."
    echo fmt"The sum of its proper divisors is {s}."
    break

echo ""
for (n, s) in oddAbundant(1_000_000_000):
  if n > 1_000_000_000:
    echo fmt"The first odd abundant number greater than 1000000000 is {n}."
    echo fmt"The sum of its proper divisors is {s}."
    break
