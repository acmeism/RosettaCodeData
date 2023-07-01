import strformat

iterator h(): (int, float) =
  ## Yield the index of the term and its value.
  var n = 1
  var r = 0.0
  while true:
    r += 1 / n
    yield (n, r)
    inc n

echo "First 20 terms of the harmonic series:"
for (idx, val) in h():
  echo &"{idx:2}: {val}"
  if idx == 20: break
echo()

var target = 1.0
for (idx, val) in h():
  if val > target:
    echo &"Index of the first term greater than {target.int:2}: {idx}"
    if target == 10: break
    else: target += 1
