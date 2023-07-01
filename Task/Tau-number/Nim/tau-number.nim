import math, strutils

func divcount(n: Natural): Natural =
  for i in 1..sqrt(n.toFloat).int:
    if n mod i == 0:
      inc result
      if n div i != i: inc result

var count = 0
var n = 1
var tauNumbers: seq[Natural]
while true:
  if n mod divcount(n) == 0:
    tauNumbers.add n
    inc count
    if count == 100: break
  inc n

echo "First 100 tau numbers:"
for i, n in tauNumbers:
  stdout.write ($n).align(5)
  if i mod 20 == 19: echo()
