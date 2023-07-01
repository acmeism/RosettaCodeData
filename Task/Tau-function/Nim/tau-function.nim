import math, strutils

func divcount(n: Natural): Natural =
  for i in 1..sqrt(n.toFloat).int:
    if n mod i == 0:
      inc result
      if n div i != i: inc result

echo "Count of divisors for the first 100 positive integers:"
for i in 1..100:
  stdout.write ($divcount(i)).align(3)
  if i mod 20 == 0: echo()
