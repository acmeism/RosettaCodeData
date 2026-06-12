import std/[math, sugar]

const
  Powers5 = collect(for n in 0..9: n ^ 5)
  Max = 6 * 9 ^ 5

type Digit = 0..9

iterator digits(n: Natural): Digit =
  var n = n
  while n != 0:
    yield n mod 10
    n = n div 10

proc sumPowers5(n: Natural): int =
  for d in n.digits:
    result += Powers5[d]

var sum = 0
for n in 2..Max:
  if n == n.sumPowers5:
    sum += n

echo sum
