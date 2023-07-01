# compile with: nim c -d:danger -t:-march=native --gc:arc

from std/monotimes import getMonoTime, `-`
from std/times import inMilliseconds
from std/math import sqrt

let masks = [ 1'u8, 2, 4, 8, 16, 32, 64, 128 ] # faster than bit twiddling
let masksp = cast[ptr[UncheckedArray[byte]]](unsafeAddr(masks[0]))

proc countPrimes(n: int64): int64 =
  if n < 3:
    return if n < 2: 0 else: 1
  else:
    let rtlmt = n.float64.sqrt.int
    let mxndx = (rtlmt - 1) div 2
    let sz = (mxndx + 8) div 8
    var cmpsts = cast[ptr[UncheckedArray[byte]]](alloc0(sz))
    for i in 1 .. mxndx:
      if (cmpsts[i shr 3] and masksp[i and 7]) != 0: continue
      let sqri = (i + i) * (i + 1)
      if sqri > mxndx: break
      let bp = i + i + 1
      for c in countup(sqri, mxndx, bp):
        let w = c shr 3; cmpsts[w] = cmpsts[w] or masksp[c and 7]
    var pisqrt = 0'i64
    for i in 0 .. mxndx:
      if (cmpsts[i shr 3] and masksp[i and 7]) == 0: pisqrt += 1
    var primes = cast[ptr[UncheckedArray[uint32]]](alloc(sizeof(uint32) * pisqrt.int))
    var j = 0
    for i in 0 .. mxndx:
      if (cmpsts[i shr 3] and masksp[i and 7]) == 0: primes[j] = (i + i + 1).uint32; j += 1
    proc phi(x: int64; a: int): int64 =
      if a <= 1:
        return if a < 1: x else: x - (x shr 1)
      let p = primes[a - 1].int64
      if x <= p: return 1 # very simple one-line optimization that limits exponential growth!
      return phi(x, a - 1) - phi((x.float64 / p.float64).int64, a - 1)
    result = phi(n, pisqrt.int) + pisqrt - 1
    cmpsts.dealloc; primes.dealloc

let nstrt = getMonoTime()
var pow = 1'i64
for i in 0 .. 9: echo "π(10^", i, ") = ", pow.countPrimes; pow *= 10
let nelpsd = (getMonoTime() - nstrt).inMilliseconds
echo "This took ", nelpsd, " milliseconds."
