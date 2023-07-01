import strformat

func fusc(n: int): int =
  if n == 0 or n == 1:
    n
  elif n mod 2 == 0:
    fusc(n div 2)
  else:
    fusc((n - 1) div 2) + fusc((n + 1) div 2)

echo "The first 61 Fusc numbers:"
for i in 0..61:
  write(stdout, fmt"{fusc(i)} ")
echo "\n\nThe Fusc numbers whose lengths are greater than those of previous Fusc numbers:"
echo fmt"        n   fusc(n)"
echo    "--------- ---------"
var maxLength = 0
for i in 0..700_000:
  var f = fusc(i)
  var length = len($f)
  if length > maxLength:
    maxLength = length
    echo fmt"{i:9} {f:9}"
