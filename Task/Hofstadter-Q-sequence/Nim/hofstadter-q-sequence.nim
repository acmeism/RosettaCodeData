var q = @[1, 1]
for n in 2 ..< 100_000: q.add q[n-q[n-1]] + q[n-q[n-2]]

echo q[0..9]
assert q[0..9] == @[1, 1, 2, 3, 3, 4, 5, 5, 6, 6]

echo q[999]
assert q[999] == 502

var lessCount = 0
for n in 1 ..< 100_000:
  if q[n] < q[n-1]:
    inc lessCount
echo lessCount
