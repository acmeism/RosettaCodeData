import strformat
from math import floor, sqrt

var
  p, s, c : int
  r: float

for i in countdown(499, 1):
  s = 1000 - i
  p = 1000 * (500 - i)
  let delta = float(s * s - 4 * p)
  r = sqrt(delta)
  if floor(r) == r:
    c = i
    break

echo fmt"Product: {p * c}"
echo fmt"a: {(s - int(r)) div 2}"
echo fmt"b: {(s + int(r)) div 2}"
echo fmt"c: {c}"
