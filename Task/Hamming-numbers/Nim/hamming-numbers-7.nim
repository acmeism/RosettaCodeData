# HammingsLogDQ.nim
# compile with:  nim c -d:danger -t:-march=native -d:LTO --gc:arc HammingsImpLogQ

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

proc `$`(lr: LogRep): string {.inline.} = $lr2BigInt(lr)

iterator hammingsLogQ(): LogRep =
  var s2msk, s3msk = 1024
  var s2 = newSeq[LogRep] s2msk; var s3 = newSeq[LogRep] s3msk
  s2msk -= 1; s3msk -= 1; s2[0] = one; var  s2nxti = 1
  var s2hdi, s3hdi, s3nxti = 0
  var s5 = one.mul5; var mrg = one.mul3
  while true:
    let s2hdp = addr(s2[s2hdi])
    if s2hdp[][0] < mrg[0]:
      s2[s2nxti] = s2hdp[].mul2; s2hdi += 1; s2hdi = s2hdi and s2msk
      yield s2hdp[]
    else:
      s2[s2nxti] = mrg.mul2; s3[s3nxti] = mrg.mul3; yield mrg
      let s3hdp = addr(s3[s3hdi])
      if s3hdp[0] < s5[0]:
        mrg = s3hdp[]; s3hdi += 1; s3hdi = s3hdi and s3msk
      else: mrg = s5; s5 = s5.mul5
      s3nxti += 1; s3nxti = s3nxti and s3msk
      if s3nxti == s3hdi: # buffer full - expand...
        let sz = s3msk + 1; s3msk = sz + sz; s3.setLen(s3msk); s3msk -= 1
        if s3hdi == 0: s3nxti = sz
        else: # put extra space between next and head...
          copyMem(addr(s3[s3hdi + sz]), addr(s3[s3hdi]),
                  sizeof(LogRep) * (sz - s3hdi)); s3hdi += sz
    s2nxti += 1; s2nxti = s2nxti and s2msk
    if s2nxti == s2hdi: # buffer full - expand...
      let sz = s2msk + 1; s2msk = sz + sz; s2.setLen s2msk; s2msk -= 1
      if s2hdi == 0: s2nxti = sz # copy all in a single block...
      else: # make extra space between next and head...
        copyMem(addr(s2[s2hdi + sz]), addr(s2[s2hdi]),
                sizeof(LogRep) * (sz - s2hdi)); s2hdi += sz

# testing it...
var cnt = 0
for h in hammingsLogQ():
  write stdout, h, " "; cnt += 1
  if cnt >= 20: break
echo ""
cnt = 0
for h in hammingsLogQ():
  cnt += 1
  if cnt >= 1691: echo h; break

let strt = getMonoTime()
var rslt: LogRep
cnt = 0
for h in hammingsLogQ():
  cnt += 1
  if cnt >= 1_000_000: rslt = h; break # """
let elpsd = (getMonoTime() - strt).inMicroseconds

let (_, x2, x3, x5) = rslt
writeLine stdout, "2^", x2, " + 3^", x3, " + 5^", x5
let lgrslt = (x2.float64 + x3.float64 * 3.0f64.log2 +
               x5.float64 * 5.0f64.log2) * 2.0f64.log10
let (whl, frac) = lgrslt.splitDecimal
echo "Approximately:  ", 10.0f64.pow(frac), "E+", whl.uint64
let s = $rslt
let ls = s.len
echo "Number of digits:  ", ls
if ls <= 2000:
  for i in countup(0, ls - 1, 100):
    if i + 100 < ls: echo s[i .. i + 99]
    else: echo s[i .. ls - 1]
echo "This last took ", elpsd, " microseconds."
