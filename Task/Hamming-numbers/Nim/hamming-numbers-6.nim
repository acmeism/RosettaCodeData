# HammingsLogImp.nim
# compile with:  nim c -d:danger -t:-march=native -d:LTO --gc:arc HammingsLogImp

import bigints, std/math
from std/times import inMicroseconds
from std/monotimes import getMonoTime, `-`

type LogRep = (float64, uint32, uint32, uint32)

let one: LogRep = (0.0, 0'u32, 0'u32, 0'u32)

let lb2 = 1.0'f64; let lb3 = 3.0.log2; let lb5 = 5.0.log2
proc mul2(me: Logrep): Logrep {.inline.} =
  (me[0] + lb2, me[1] + 1, me[2], me[3])
proc mul3(me: Logrep): Logrep {.inline.} =
  (me[0] + lb3, me[1], me[2] + 1, me[3])
proc mul5(me: Logrep): Logrep {.inline.} =
  (me[0] + lb5, me[1], me[2], me[3] + 1)

proc lr2BigInt(lr: Logrep): BigInt =
  proc xpnd(bs: uint, v: uint32): BigInt =
    result = initBigInt 1
    var bsm = initBigInt bs;
    var vm = v.uint
    while vm > 0:
      if (vm and 1) != 0: result *= bsm
      bsm *= bsm; vm = vm shr 1
  xpnd(2, lr[1]) * xpnd(3, lr[2]) * xpnd(5, lr[3])

iterator hammingsLogImp(): LogRep =
  var
    s2 = newSeq[Logrep](1024) # give it size one so doubling size works
    s3 = newSeq[Logrep](1024) # reasonably sized
    s5 = one.mul5 # initBigInt 5
    mrg = one.mul3 # initBigInt 3
    s2hdi, s2tli, s3hdi, s3tli = 0

  yield one
  s2[0] = one.mul2; s3[0] = one.mul3
  while true:
    s2tli += 1
    if s2hdi + s2hdi >= s2tli: # move in-place to avoid allocation
      copyMem(addr(s2[0]), addr(s2[s2hdi]), sizeof(LogRep) * (s2tli - s2hdi))
      s2tli -= s2hdi; s2hdi = 0
    let cps2 = s2.len # move in-place to avoid allocation
    if s2tli >= cps2: s2.setLen(cps2 + cps2)
    var rsltp = addr(s2[s2hdi])
    if rsltp[][0] < mrg[0]: s2[s2tli] = rsltp[].mul2; s2hdi += 1; yield rsltp[]
    else:
      s3tli += 1
      if s3hdi + s3hdi >= s3tli: # move in-place to avoid allocation
        copyMem(addr(s3[0]), addr(s3[s3hdi]), sizeof(LogRep) * (s3tli - s3hdi))
        s3tli -= s3hdi; s3hdi = 0
      let cps3 = s3.len
      if s3tli >= cps3: s3.setLen(cps3 + cps3)
      s2[s2tli] = mrg.mul2; s3[s3tli] = mrg.mul3; s3hdi += 1
      let arsltp = addr(s3[s3hdi])
      let rslt = mrg
      if arsltp[][0] < s5[0]: mrg = arsltp[]
      else: mrg = s5; s5 = s5.mul5; s3hdi -= 1
      yield rslt

var cnt = 0
for h in hammingsLogImp():
  write stdout, h.lr2BigInt, " "; cnt += 1
  if cnt >= 20: break
echo ""
cnt = 0
for h in hammingsLogImp():
  cnt += 1
  if cnt >= 1691: echo h.lr2BigInt; break

let strt = getMonoTime()
var rslt: LogRep
cnt = 0
for h in hammingsLogImp():
  cnt += 1
  if cnt >= 1_000_000: rslt = h; break # """
let elpsd = (getMonoTime() - strt).inMicroseconds

let (_, x2, x3, x5) = rslt
writeLine stdout, "2^", x2, " + 3^", x3, " + 5^", x5
let lgrslt = (x2.float64 + x3.float64 * 3.0f64.log2 +
               x5.float64 * 5.0f64.log2) * 2.0f64.log10
let (whl, frac) = lgrslt.splitDecimal
echo "Approximately:  ", 10.0f64.pow(frac), "E+", whl.uint64
let brslt = rslt.lr2BigInt()
let s = brslt.to_string
let ls = s.len
echo "Number of digits:  ", ls
if ls <= 2000:
  for i in countup(0, ls - 1, 100):
    if i + 100 < ls: echo s[i .. i + 99]
    else: echo s[i .. ls - 1]
echo "This last took ", elpsd, " microseconds."
