import std/math, std/strutils
from std/times import inMilliseconds
from std/monotimes import getMonoTime, `-`

let lgshft = 50; let lg10 =  1'u64 shl lgshft; let fac = 2'f64.pow lgshft.float64
let lg7 = (7'f64.log10 * fac).round.uint64
let lg5 = (5'f64.log10 * fac).round.uint64
let lg3 = (3'f64.log10 * fac).round.uint64; let lg2 = lg10 - lg5

proc lr2UInt64(lr: uint64): uint64 = pow(10, (lr.float64 / fac)).round.uint64

iterator humblesLogQ(): uint64 = # {.closure.} =
  var hd2 = lg2; var hd3 = lg3; var hd5 = lg5; var hd7 = lg7
  var s2msk, s2hdi, s2tli, s3msk, s3hdi, s3tli, s5msk, s5hdi, s5tli = 0
  var s2 = newSeq[uint64] 0
  var s3 = newSeq[uint64] 0
  var s5 = newSeq[uint64] 0
  yield 0'u64
  while true:
    yield hd2
    if s2tli == s2hdi:
      let osz = if s2msk == 0: 512 else: s2msk + 1
      s2.setLen (osz + osz); s2msk = s2.len - 1
      if osz > 512:
        if s2hdi == 0: s2tli = osz
        else: # put extra space between tail and head...
          copyMem(addr(s2[s2hdi + osz]), addr(s2[s2hdi]),
                  sizeof(uint64) * (osz - s2hdi)); s2hdi += osz
    s2[s2tli] = hd2 + lg2; s2tli = (s2tli + 1) and s2msk
    hd2 = s2[s2hdi]
    if hd2 < hd3: s2hdi = (s2hdi + 1) and s2msk
    else:
      hd2 = hd3
      if s3tli == s3hdi:
        let osz = if s3msk == 0: 512 else: s3msk + 1
        s3.setLen (osz + osz); s3msk = s3.len - 1
        if osz > 512:
          if s3hdi == 0: s3tli = osz
          else: # put extra space between tail and head...
            copyMem(addr(s3[s3hdi + osz]), addr(s3[s3hdi]),
                    sizeof(uint64) * (osz - s3hdi)); s3hdi += osz
      s3[s3tli] = hd3 + lg3; s3tli = (s3tli + 1) and s3msk
      hd3 = s3[s3hdi]
      if hd3 < hd5: s3hdi = (s3hdi + 1) and s3msk
      else:
        hd3 = hd5
        if s5tli == s5hdi:
          let osz = if s5msk == 0: 512 else: s5msk + 1
          s5.setLen (osz + osz); s5msk = s5.len - 1
          if osz > 512:
            if s5hdi == 0: s5tli = osz
            else: # put extra space between tail and head...
              copyMem(addr(s5[s5hdi + osz]), addr(s5[s5hdi]),
                      sizeof(uint64) * (osz - s5hdi)); s5hdi += osz
        s5[s5tli] = hd5 + lg5; s5tli = (s5tli + 1) and s5msk
        hd5 = s5[s5hdi]
        if hd5 < hd7: s5hdi = (s5hdi + 1) and s5msk
        else: hd5 = hd7; hd7 += lg7

proc commaString(s: string): string =
  let sz = s.len; let sqlen = (sz + 2) div 3
  var sq = newSeq[string](sqlen); var ndx = sqlen - 1
  for i in countdown(sz - 1, 0, 3): sq[ndx] = s[(max(i-2, 0) .. i)]; ndx -= 1
  sq.join ","

# testing it...
let numdigits = 877.uint64

echo "First 50 Humble numbers:"
var cnt = 0
for h in humblesLogQ():
  stdout.write $h.lr2UInt64, " "; cnt += 1
  if cnt >= 50: break

echo "\r\nCount of humble numbers for each digit length 1-", $numdigits, ":"
echo "Digits       Count              Accum"
let lmt = lg10 * numdigits
let strt = getMonoTime()
var bins = newSeq[int](numdigits)
for w in countup(0'u64, lmt, lg7):
  for x in countup(w, lmt, lg5):
    for y in countup(x, lmt, lg3):
      for z in countup(y, lmt, lg2):
        bins[z shr lgshft] += 1
var a = 0
for i, c in bins:
  a += c
  echo ($(i + 1)).align(4) & ($c).commaString.align(14) &
            ($a).commaString.align(19)
let elpsd = (getMonoTime() - strt).inMilliseconds
echo "Counting took ", elpsd, " milliseconds."
