import strformat

const MAX = 15

func countDivisors(n: int): int =
  var i = 1
  var count = 0
  while i * i <= n:
    if n mod i == 0:
      if i == n div i:
        inc count
      else:
        inc count, 2
    inc i
  count

var i, next = 1
echo fmt"The first {MAX} terms of the sequence are:"
while next <= MAX:
  if next == countDivisors(i):
    write(stdout, fmt"{i} ")
    inc next
  inc i
write(stdout, "\n")
