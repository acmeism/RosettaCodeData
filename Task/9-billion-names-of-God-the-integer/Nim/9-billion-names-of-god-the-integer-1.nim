import bigints

var cache = @[@[1.initBigInt]]

proc cumu(n): seq[BigInt] =
  for l in cache.len .. n:
    var r = @[0.initBigInt]
    for x in 1..l:
      r.add r[r.high] + cache[l-x][min(x, l-x)]
    cache.add r
  result = cache[n]

proc row(n): seq[BigInt] =
  let r = cumu n
  result = @[]
  for i in 0 .. <n:
    result.add r[i+1] - r[i]

echo "rows:"
for x in 1..10:
  echo row x

echo "sums:"
for x in [23, 123, 1234, 12345]:
  let c = cumu(x)
  echo x, " ", c[c.high]
