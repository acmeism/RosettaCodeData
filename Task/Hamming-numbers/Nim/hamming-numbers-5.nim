import bigints, math, sequtils, times

proc convertTrival2BigInt(tpl: (uint32, uint32, uint32)): BigInt =
  result = initBigInt 1
  let (x, y, z) = tpl
  for _ in 1 .. x: result *= 2
  for _ in 1 .. y: result *= 3
  for _ in 1 .. z: result *= 5

iterator log_nodups_hamming(): (uint32, uint32, uint32) =
  let lb3 = 3.0f64.log2; let lb5 = 5.0f64.log2
  type Logrep = (float64, (uint32, uint32, uint32))
  proc `<`(me: Logrep, othr: Logrep): bool =
    let (lme, _) = me; let (lothr, _) = othr
    lme < lothr
  proc mul2(me: Logrep): Logrep =
    let (lr, tpl) = me; let (x2, x3, x5) = tpl
    (lr + 1.0f64, (x2 + 1, x3, x5))
  proc mul3(me: Logrep): Logrep =
    let (lr, tpl) = me; let (x2, x3, x5) = tpl
    (lr + lb3, (x2, x3 + 1, x5))
  proc mul5(me: Logrep): Logrep =
    let (lr, tpl) = me; let (x2, x3, x5) = tpl
    (lr + lb5, (x2, x3, x5 + 1))

  let one: Logrep = (0.0f64, (0u32, 0u32, 0u32))
  var
    m = newSeq[Logrep](1) # give it two values so doubling size works
    h = newSeq[Logrep](1) # reasonably size
    x5 = one.mul5 # initBigInt 5
    mrg = one.mul3 # initBigInt 3
    x53 = one.mul3().mul3 # initBigInt 9 # already advanced one step
    x532 = one.mul2 # initBigInt 2
    ih, jm, i, j = 0

  yield (0u32, 0u32, 0u32)
  while true:
    let cph = h.len # move in-place to avoid allocation
    if i >= cph div 2: # move in-place to avoid allocation
      var s = i; var d = 0
      while s < ih: shallowCopy(h[d], h[s]); s += 1; d += 1
      ih -= i; i = 0
    if ih >= cph: h.setLen(2 * cph)
    if x532 < mrg: h[ih] = x532; x532 = h[i].mul2; i += 1
    else:
      h[ih] = mrg
      let cpm = m.len
      if j >= cpm div 2: # move in-place to avoid allocation
        var s = j; var d = 0
        while s < jm: shallowCopy(m[d], m[s]); s += 1; d += 1
        jm -= j; j = 0
      if jm >= cpm: m.setLen(2 * cpm)
      if x53 < x5: mrg = x53; x53 = m[j].mul3; j += 1
      else: mrg = x5; x5 = x5.mul5
      m[jm] = mrg
      jm += 1
    ih += 1

    let (_, rslt) = h[ih - 1]
    yield rslt

var cnt = 1
for h in log_nodups_hamming():
  if cnt > 20: break
  write stdout, h.convertTrival2BigInt, " "; cnt += 1
echo ""
cnt = 1
for h in log_nodups_hamming():
  if cnt < 1691: cnt += 1; continue
  else: echo h.convertTrival2BigInt; break

let strt = epochTime()
var rslt: (uint32, uint32, uint32)
cnt = 1
for h in log_nodups_hamming():
  if cnt < 1000000: cnt += 1; continue
  else: rslt = h; break # """
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
