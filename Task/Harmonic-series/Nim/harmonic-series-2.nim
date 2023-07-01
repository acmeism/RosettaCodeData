import strformat
import bignum

iterator h(): (int, Rat) =
  var n = 1
  var r = newRat()
  while true:
    r += newRat(1, n)
    yield (n, r)
    inc n

echo "First 20 terms of the harmonic series:"
for (idx, val) in h():
  echo &"{idx:2}: {val}"
  if idx == 20: break
echo()

var target = 1
for (idx, val) in h():
  if val > target:
    echo &"Index of the first term greater than {target:2}: {idx}"
    if target == 10: break
    else: inc target
