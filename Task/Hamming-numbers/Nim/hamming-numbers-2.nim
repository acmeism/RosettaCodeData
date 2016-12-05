import bigints, times

proc hamming(limit: int): BigInt =
  doAssert limit > 0
  var
    h = newSeq[BigInt](limit)
    x2 = initBigInt(2)
    x3 = initBigInt(3)
    x5 = initBigInt(5)
    i, j, k = 0
  h[0] = initBigInt 1

  # BigInt comparisons are expensive, reduce them...
  proc min3(x, y, z: BigInt): (int, BigInt) =
    let (cs, r1) = if y == z: (0x6, y)
                   elif y < z: (2, y) else: (4, z)
    if x == r1: (cs or 1, x)
    elif x < r1: (1, x) else: (cs, r1)

  for n in 1 .. < limit:
    let (cs, e1) = min3(x2, x3, x5)
    h[n] = e1
    if (cs and 1) != 0: i += 1; x2 = h[i] * 2
    if (cs and 2) != 0: j += 1; x3 = h[j] * 3
    if (cs and 4) != 0: k += 1; x5 = h[k] * 5

  h[h.high]

for i in 1 .. 20:
  write stdout, hamming(i), " "
echo ""
echo hamming(1691)

let strt = epochTime()
let rslt = hamming(1_000_000)
let stop = epochTime()

echo rslt
echo "This last took ", (stop - strt)*1000, " milliseconds."
