import std/[sequtils, strutils, sugar]

type Bit = 0..1

proc e(k, n: Natural): seq[Bit] =
  var d = n - k
  var s = repeat(@[Bit 1], k) & repeat(@[Bit 0], d)
  var n = max(k, d)
  var k = min(k, d)
  var z = d

  while z > 0 or k > 1:
    for i in 0..<k:
      s[i].add s[s.high - i]
    s.setLen(s.len - k)
    z -= k
    d = n - k
    n = max(k, d)
    k = min(k, d)

  result = collect:
             for subList in s:
               for item in subList:
                 item

echo e(5,13).join()
