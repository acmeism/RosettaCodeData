import std/strutils

func digitSum(n: Natural): int =
  ## Return the sum of digits of "n".
  var n = n
  while n != 0:
    result.inc n mod 10
    n = n div 10

iterator a131382(count: Natural): (int, int) =
  ## Yield the index and value of the first "count" elements
  ## of the sequence.
  for n in 1..count:
    var m = 1
    while digitSum(m * n) != n:
      inc m
    yield (n, m)

for idx, n in a131382(70):
  stdout.write align($n, 9)
  if idx mod 10 == 0: stdout.write '\n'
