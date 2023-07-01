import algorithm, sequtils, std/monotimes, times

type Digit = 0..9

var digits = newSeqOfCap[Digit](10)

proc getDigits(n: Positive) =
  digits.setLen(0)
  var n = n.int
  while n != 0:
    digits.add n mod 10
    n = n div 10
  digits.reverse()

proc isSelfDescribing(n: Natural): bool =
  n.getDigits()
  for i, d in digits:
    if digits.count(i) != d:
      return false
  result = true

let t0 = getMonoTime()
for n in 1 .. 1_000_000_000:
  if n.isSelfDescribing:
    echo n, " in ", getMonoTime() - t0

echo "\nTotal time: ", getMonoTime() - t0
