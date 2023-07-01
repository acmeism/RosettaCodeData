import bigints, math, algorithm, times

type TriVal = (uint32, uint32, uint32)

proc convertTrival2BigInt(tv: TriVal): BigInt =

  proc xpnd(bs: uint, v: uint32): BigInt =
    result = initBigInt 1
    var bsm = initBigInt bs
    var vm = v.uint
    while vm > 0:
      if (vm and 1) != 0: result *= bsm
      bsm = bsm * bsm     # bsm *= bsm causes a crash.
      vm = vm shr 1

  result = (2.xpnd  tv[0]) * (3.xpnd tv[1]) * (5.xpnd tv[2])

proc nth_hamming(n: uint64): TriVal =
  doAssert n > 0u64
  if n < 2: return (0'u32, 0'u32, 0'u32) # trivial case for 1

  type LogRep = (float64, uint32, uint32, uint32)

  let lb3 = 3.0'f64.log2; let lb5 = 5.0'f64.log2; let fctr = 6.0'f64*lb3*lb5
  let
    crctn = 30.0'f64.sqrt().log2 # log base 2 of sqrt 30
    lgest = (fctr * n.float64).pow(1.0'f64/3.0'f64) - crctn # from WP formula
    frctn = if n < 1000000000: 0.509'f64 else: 0.105'f64
    lghi = (fctr * (n.float64 + frctn * lgest)).pow(1.0'f64/3.0'f64) - crctn
    lglo = 2.0'f64 * lgest - lghi # and a lower limit of the upper "band"
  var count = 0'u64 # need to use extended precision, might go over
  var bnd = newSeq[LogRep](1) # give itone value so doubling size works
  let klmt = (lghi / lb5).uint32 + 1
  for k in 0 ..< klmt: # i, j, k values can be just u32 values
    let p = k.float64 * lb5; let jlmt = ((lghi - p) / lb3).uint32 + 1
    for j in 0 ..< jlmt:
      let q = p + j.float64 * lb3
      let ir = lghi - q; let lg = q + ir.floor # current log value (estimated)
      count += ir.uint64 + 1;
      if lg >= lglo: bnd.add((lg, ir.uint32, j, k))
  if n > count: raise newException(Exception, "nth_hamming: band high estimate is too low!")
  let ndx = (count - n).int
  if ndx >= bnd.len: raise newException(Exception, "nth_hamming: band low estimate is too high!")
  bnd.sort((proc (a, b: LogRep): int = a[0].cmp b[0]), SortOrder.Descending)

  let rslt = bnd[ndx]; (rslt[1], rslt[2], rslt[3])

for i in 1 .. 20:
  write stdout, nth_hamming(i.uint64).convertTrival2BigInt, " "
echo ""
echo nth_hamming(1691).convertTrival2BigInt

let strt = epochTime()
let rslt = nth_hamming(1_000_000'u64)
let stop = epochTime()

let (x2, x3, x5) = rslt
writeLine stdout, "2^", x2, " + 3^", x3, " + 5^", x5
let lgrslt = (x2.float64 + x3.float64 * 3.0f64.log2 +
               x5.float64 * 5.0f64.log2) * 2.0f64.log10
let (whl, frac) = lgrslt.splitDecimal
echo "Approximately:  ", 10.0f64.pow(frac), "E+", whl.uint64
let brslt = rslt.convertTrival2BigInt()
let s = brslt.to_string
let ls = s.len
echo "Number of digits:  ", ls
if ls <= 2000:
  for i in countup(0, ls - 1, 100):
    if i + 100 < ls: echo s[i .. i + 99]
    else: echo s[i .. ls - 1]

echo "This last took ", (stop - strt) * 1000, " milliseconds."
