import strformat

proc properDivisors(n: int) =
  var count = 0
  for i in 1..<n:
    if n mod i == 0:
      inc count
      write(stdout, fmt"{i} ")
  write(stdout, "\n")

proc countProperDivisors(n: int): int =
  var nn = n
  var prod = 1
  var count = 0
  while nn mod 2 == 0:
    inc count
    nn = nn div 2
  prod *= (1 + count)
  for i in countup(3, n, 2):
    count = 0
    while nn mod i == 0:
      inc count
      nn = nn div i
    prod *= (1 + count)
  if nn > 2:
    prod *= 2
  prod - 1

for i in 1..10:
  write(stdout, fmt"{i:2}: ")
  properDivisors(i)

var max = 0
var maxI = 1

for i in 1..20000:
  var v = countProperDivisors(i)
  if v >= max:
    max = v
    maxI = i

echo fmt"{maxI} with {max} divisors"
