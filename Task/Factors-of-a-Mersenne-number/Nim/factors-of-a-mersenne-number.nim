import math

proc isPrime(a: int): bool =
  if a == 2: return true
  if a < 2 or a mod 2 == 0: return false
  for i in countup(3, int sqrt(float a), 2):
    if a mod i == 0:
      return false
  return true

const q = 929
if not isPrime q: quit 1
var r = q
while r > 0: r = r shl 1
var d = 2 * q + 1
while true:
  var i = 1
  var p = r
  while p != 0:
    i = (i * i) mod d
    if p < 0: i *= 2
    if i > d: i -= d
    p = p shl 1
  if i != 1: d += 2 * q
  else: break
echo "2^",q," - 1 = 0 (mod ",d,")"
