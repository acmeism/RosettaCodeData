import bigints, math, sequtils, algorithm, times

proc nth_hamming(n: uint64): (uint32, uint32, uint32) =
  doAssert n > 0u64
  if n < 2: return (0u32, 0u32, 0u32) # trivial case for 1

  type Logrep = (float64, (uint32, uint32, uint32))

  let
    lb3 = 3.0f64.log2
    lb5 = 5.0f64.log2
    fctr = 6.0f64 * lb3 * lb5
    crctn = 30.0f64.sqrt().log2 # log base 2 of sqrt 30
    lgest = (fctr * n.float64).pow(1.0f64/3.0f64) - crctn # from WP formula
    frctn = if n < 1000000000: 0.509f64 else: 0.105f64
    lghi = (fctr * (n.float64 + frctn * lgest)).pow(1.0f64/3.0f64) - crctn
    lglo = 2.0f64 * lgest - lghi # and a lower limit of the upper "band"
  var count = 0u64 # need to use extended precision, might go over
  var bnd = newSeq[Logrep](1) # give itone value so doubling size works
  let klmt = uint32(lghi / lb5) + 1
  for k in 0 ..< klmt: # i, j, k values can be just u32 values
    let p = k.float64 * lb5
    let jlmt = uint32((lghi - p) / lb3) + 1
    for j in 0 ..< jlmt:
      let q = p + j.float64 * lb3
      let ir = lghi - q
      let lg = q + ir.floor # current log value (estimated)
      count += ir.uint64 + 1;
      if lg >= lglo:
        bnd.add((lg, (ir.uint32, j, k)))
  if n > count: raise newException(Exception, "nth_hamming: band high estimate is too low!")
  let ndx = (count - n).int
  if ndx >= bnd.len: raise newException(Exception, "nth_hamming: band low estimate is too high!")
  bnd.sort((proc (a, b: Logrep): int = # sort decreasing order
    let (la, _) = a; let (lb, _) = b
    la.cmp lb), SortOrder.Descending)

  let (_, rslt) = bnd[ndx]
  rslt

let num_hammings = 1_000_000_000_000u64

for i in 1 .. 20:
  write stdout, nth_hamming(i.uint64).convertTrival2BigInt, " "
echo ""
echo nth_hamming(1691).convertTrival2BigInt

let strt = epochTime()
let rslt = nth_hamming(num_hammings)
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

echo "This last took ", (stop - strt)*1000, " milliseconds."
