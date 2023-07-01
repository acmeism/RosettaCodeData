import std/[math, strutils]

func pow(a, n: Natural; m: Positive): Natural =
  var a = a mod m
  var n = n
  if a > 0:
    result = 1
    while n > 0:
      if (n and 1) != 0:
        result = (result * a) mod m
      n = n shr 1
      a = (a * a) mod m

func sqrt(n: Natural): Natural = Natural(sqrt(float(n)))

func isDeceptive(n: Natural): bool =
  if (n and 1) != 0 and n mod 3 != 0 and n mod 5 != 0 and pow(10, n - 1, n) == 1:
    for d in countup(7, sqrt(n), 6):
      if n mod d == 0 or n mod (d + 4) == 0:
        return true
  result = false

var count = 0
var n = 7
while true:
  if n.isDeceptive:
    inc count
    stdout.write align($n, 6)
    stdout.write if count mod 10 == 0: '\n' else: ' '
    if count == 100: break
  inc n
