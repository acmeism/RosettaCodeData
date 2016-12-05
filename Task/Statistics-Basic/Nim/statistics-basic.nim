import math, strutils
randomize()

proc sd(ns): auto =
  var sx, sxx = 0.0
  for x in ns:
    sx += x
    sxx += x * x
  let sd = if ns.len > 0: sqrt(float(ns.len) * sxx - sx * sx) / float(ns.len)
           else: 0
  (sd, sx / float(ns.len))

proc histogram(ns) =
  var h = newSeq[int](10)
  for n in ns:
    let pos = int(n * 10)
    inc h[pos]

  const maxWidth = 50
  let mx = max(h)
  echo ""
  for n, i in h:
    echo n/10,": ",repeatChar(int(i / mx * maxWidth), '+')
  echo ""

for i in [10, 100, 1_000, 10_000, 100_000]:
  var n = newSeq[float](i)
  for x in 0..n.high: n[x] = random(1.0)
  echo "\n##\n## ",i," numbers\n##"
  let (sd, mean) = sd(n)
  echo "sd: ",sd,", mean: ",mean
  histogram(n)
