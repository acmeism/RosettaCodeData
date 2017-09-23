import bigints

var cache = @[@[1.initBigInt]]

proc cumu(n: int): seq[BigInt] =
  for m in cache.len .. n:
    var r = @[0.initBigInt]
    for x in 1..m:
      r.add r[r.high] + cache[m-x][min(x, m-x)]
    cache.add r
  result = cache[n]

proc row(n: int): seq[BigInt] =
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
