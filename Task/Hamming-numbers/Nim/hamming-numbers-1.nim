import bigints

proc min(a: varargs[BigInt]): BigInt =
  result = a[0]
  for i in 1..a.high:
    if a[i] < result: result = a[i]

proc hamming(limit: int): BigInt =
  var
    h = newSeq[BigInt](limit)
    x2 = initBigInt(2)
    x3 = initBigInt(3)
    x5 = initBigInt(5)
    i, j, k = 0
  for i in 0..h.high: h[i] = initBigInt(1)

  for n in 1 ..< limit:
    h[n] = min(x2, x3, x5)
    if x2 == h[n]:
      inc i
      x2 = h[i] * 2
    if x3 == h[n]:
      inc j
      x3 = h[j] * 3
    if x5 == h[n]:
      inc k
      x5 = h[k] * 5

  result = h[h.high]

for i in 1 .. 20:
  stdout.write hamming(i), " "
echo ""
echo hamming(1691)
echo hamming(1_000_000)
