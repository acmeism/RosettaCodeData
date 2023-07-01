import strformat, strutils

func isPrime(n: Positive): bool =
  if n == 1: return false
  if (n and 1) == 0: return n == 2
  if n mod 3 == 0: return n == 3
  var d = 5
  while d * d <= n:
    if n mod d == 0: return false
    inc d, 2
    if n mod d == 0: return false
    inc d, 4
  result = true

func motzkin(n: Positive): seq[int64] =
  result.setLen(n + 1)
  result[0] = 1
  result[1] = 1
  for i in 2..n:
    result[i] = (result[i-1] * (2 * i + 1) + result[i-2] * (3 * i - 3)) div (i + 2)

echo " n          M[n]             Prime?"
echo "-----------------------------------"
var m = motzkin(41)
for i, val in m:
  echo &"{i:2}  {insertSep($val):>23}  {val.isPrime}"
