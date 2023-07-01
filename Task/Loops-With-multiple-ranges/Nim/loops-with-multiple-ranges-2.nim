import math, strutils

var
  prod = 1
  sum = 0

let
  x = +5
  y = -5
  z = -2
  one = 1
  three = 3
  seven = 7

type Range = tuple[first, last, step: int]

func initRange(first, last, step = 1): Range = (first, last, step)

iterator loop(ranges: varargs[Range]): int =
  for r in ranges:
    if r.step > 0:
      for i in countup(r.first, r.last, r.step):
        yield i
    elif r.step < 0:
      for i in countdown(r.first, r.last, -r.step):
        yield i
    else:
      raise newException(ValueError, "step cannot be zero")

for j in loop(initRange(-three, 3^3, three),
              initRange(-seven, seven, x),
              initRange(555, 550 - y),
              initRange(22, -28, three),
              initRange(1927, 1939),
              initRange(x, y, -z),
              initRange(11^x, 11^x + one)):
  sum += abs(j)
  if abs(prod) < 2^27 and j != 0: prod *= j

let s = ($sum).insertSep(',')
let p = ($prod).insertSep(',')
let m = max(s.len, p.len)
echo " sum = ", s.align(m)
echo "prod = ", p.align(m)
