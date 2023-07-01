import strformat

func totient(n: int): int =
  var tot = n
  var nn = n
  var i = 2
  while i * i <= nn:
    if nn mod i == 0:
      while nn mod i == 0:
        nn = nn div i
      dec tot, tot div i
    if i == 2:
      i = 1
    inc i, 2
  if nn > 1:
    dec tot, tot div nn
  tot

var n = 1
var num = 0
echo "The first 20 perfect totient numbers are:"
while num < 20:
  var tot = n
  var sum = 0
  while tot != 1:
    tot = totient(tot)
    inc sum, tot
  if sum == n:
    write(stdout, fmt"{n} ")
    inc num
  inc n, 2
write(stdout, "\n")
