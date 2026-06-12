import math, strutils

func divisors(n: Positive): seq[int] =
  result = @[1, n]
  for i in 2..sqrt(n.toFloat).int:
    if n mod i == 0:
      let j = n div i
      result.add i
      if i != j: result.add j

echo "Product of divisors for the first 50 positive numbers:"
for n in 1..50:
  stdout.write ($prod(n.divisors)).align(10), if n mod 5 == 0: '\n' else: ' '
