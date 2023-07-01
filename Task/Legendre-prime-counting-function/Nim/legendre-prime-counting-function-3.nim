# compile with: nim c -d:danger -t:-march=native --gc:arc

from std/monotimes import getMonoTime, `-`
from std/times import inMilliseconds
from std/math import sqrt

let masks = [ 1'u8, 2, 4, 8, 16, 32, 64, 128 ] # faster than bit twiddling
let masksp = cast[ptr[UncheckedArray[byte]]](unsafeAddr(masks[0]))

const TinyPhiPrimes = [2, 3, 5, 7, 11, 13]
const TinyPhiCirc = 3 * 5 * 7 * 11 * 13
const TinyPhiRes = 2 * 4 * 6 * 10 * 12
const CC = 6
proc makeTinyPhiLUT(): array[TinyPhiCirc, uint16] =
  for i in 0 .. TinyPhiCirc - 1: result[i] = 1
  for i in 1 .. 6:
    if result[i] == 0: continue
    result[i] = 0; let bp = i + i + 1
    let sqri = (i + i) * (i + 1)
    for c in countup(sqri, TinyPhiCirc - 1, bp): result[c] = 0
  var acc = 0'u16;
  for i in 0 .. TinyPhiCirc - 1: acc += result[i]; result[i] = acc
const TinyPhiLUT = makeTinyPhiLUT()
proc tinyPhi(x: int64): int64 {.inline.} =
  let ndx = (x - 1) div 2; let numtot = ndx div TinyPhiCirc.int64
  return numtot * TinyPhiRes.int64 + TinyPhiLUT[(ndx - numtot * TinyPhiCirc.int64).int].int64

proc countPrimes(n: int64): int64 =
  if n < 169: # below 169 whose sqrt is 13 is where TinyPhi doesn't work...
    if n < 3: return if n < 2: 0 else: 1
    # adjust for the missing "degree" base primes
    if n <= 13: return (n - 1) div 2 + (if n < 9: 1 else: 0)
    return 5 + TinyPhiLUT[(n - 1).int div 2].int64
  let rtlmt = n.float64.sqrt.int
  let mxndx = (rtlmt - 1) div 2
  var cmpsts = cast[ptr[UncheckedArray[byte]]](alloc0((mxndx + 8) div 8))
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
  let primes = cast[ptr[UncheckedArray[uint32]]](alloc(sizeof(uint32) * pisqrt.int))
  var j = 0
  for i in 0 .. mxndx:
    if (cmpsts[i shr 3] and masksp[i and 7]) == 0: primes[j] = (i + i + 1).uint32; j += 1
  var phi = tinyPhi(n)
  proc lvl(m, mbf: int64; mxa: int) = # recurse from bottom left of "tree"...
    for a in CC .. mxa:
      let p = primes[a].int64
      if m < p * p: phi += mbf * (mxa - a + 1).int64; return # rest of level all ones!
      let nm = (m.float64 / p.float64).int64; phi += mbf * tinyPhi(nm)
      if a > CC: lvl(nm, -mbf, a - 1) # split
    # finished level!
  lvl(n, -1, pisqrt.int - 1); result = phi + pisqrt - 1
  cmpsts.dealloc; primes.dealloc

let strt = getMonoTime()
var pow = 1'i64
for i in 0 .. 9: echo "π(10^", i, ") = ", pow.countPrimes; pow *= 10
let elpsd = (getMonoTime() - strt).inMilliseconds
echo "This took ", elpsd, " milliseconds."
