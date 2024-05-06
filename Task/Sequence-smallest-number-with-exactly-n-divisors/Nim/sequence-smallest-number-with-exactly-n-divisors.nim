import strformat

const MAX = 15

func countDivisors(n: int): int =
  var count = 0
  var i = 1
  while i * i <= n:
    if n mod i == 0:
      if i == n div i:
        inc count, 1
      else:
        inc count, 2
    inc i
  count

var sequence: array[MAX, int]
echo fmt"The first {MAX} terms of the sequence are:"
var i = 1
var n = 0
while n < MAX:
  var k = countDivisors(i)
  if k <= MAX and sequence[k - 1] == 0:
    sequence[k - 1] = i
    inc n
  inc i
echo sequence
