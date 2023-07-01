import strformat, strutils
import bignum

func rank(list: openArray[uint]): Int =
  result = newInt(0)
  for n in list:
    result = result shl (n + 1)
    result = result.setBit(n)

func unrank(n: Int): seq[uint] =
  var m = n.clone
  var a = if m.isZero: 0u else: m.bitLen.uint
  while a > 0:
    m = m.clearBit(a - 1)
    let b = if m.isZero: 0u else: m.bitLen.uint
    result.add(a - b - 1)
    a = b

when isMainModule:

  var b: Int
  for i in 0..10:
    b = newInt(i)
    let u = b.unrank()
    let r = u.rank()
    echo &"{i:2d} {u:>9s} {r:>2s}"

  b = newInt("12345678901234567890")
  let u = b.unrank()
  let r = u.rank()
  echo &"\n{b}\n{u}\n{r}"
