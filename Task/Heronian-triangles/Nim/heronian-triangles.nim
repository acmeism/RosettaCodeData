import math, algorithm, strfmt, sequtils

type
  HeronianTriangle = tuple
    a: int
    b: int
    c: int
    s: float
    A: int

proc `$` (t: HeronianTriangle): string =
  fmt("{:3d}, {:3d}, {:3d}\t{:7.3f}\t{:3d}", t.a, t.b, t.c, t.s, t.A)

proc hero(a:int, b:int, c:int): tuple[s, A: float] =
  let s: float = (a + b + c) / 2
  result = (s, sqrt( s * (s - float(a)) * (s - float(b)) * (s - float(c)) ))

proc isHeronianTriangle(x: float): bool = ceil(x) == x and x.toInt > 0

proc gcd(x: int, y: int): int =
  var
    (dividend, divisor) = if x > y: (x, y) else: (y, x)
    remainder = dividend mod divisor

  while remainder != 0:
    dividend = divisor
    divisor = remainder
    remainder = dividend mod divisor
  result = divisor


var list = newSeq[HeronianTriangle]()
const max = 200

for c in 1..max:
  for b in 1..c:
    for a in 1..b:
      let (s, A) = hero(a, b, c)
      if isHeronianTriangle(A) and gcd(a, gcd(b, c)) == 1:
        let t:HeronianTriangle = (a, b, c, s, A.toInt)
        list.add(t)

echo "Numbers of Heronian Triangle : ", list.len

list.sort do (x, y: HeronianTriangle) -> int:
  result = cmp(x.A, y.A)
  if result == 0:
    result = cmp(x.s, y.s)
    if result == 0:
      result = cmp(max(x.a, x.b, x.c), max(y.a, y.b, y.c))

echo "Ten first Heronian triangle ordered : "
echo "Sides          Perimeter Area"
for t in list[0 .. <10]:
  echo t

echo "Heronian triangle ordered with Area 210 : "
echo "Sides          Perimeter Area"
for t in list.filter(proc (x: HeronianTriangle): bool = x.A == 210):
  echo t
