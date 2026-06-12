import std/[algorithm, math, strutils]

func digits(n: Positive): seq[int] =
  ## Return the sequence of digits of "n".
  var n = n.Natural
  while n != 0:
    result.add n mod 10
    n = n div 10
  result.reverse()

func toInt(digits: seq[int]): int =
  ## Convert a sequence of digits to an integer.
  for d in digits:
    result = 10 * result + d

func isSquare(n: int): bool =
  ## Return true if "n" is square.
  let r = sqrt(n.toFloat).int
  result = r * r == n

echo "First eight sub-unit squares:"
echo 1
var n = 0
var count = 1
while count < 8:
  inc n, 5
  block Check:
    var digs = digits(n * n)
    for d in digs.mitems:
      if d == 9: break Check
      inc d
    let s = digs.toInt
    if s.isSquare:
      inc count
      echo s
