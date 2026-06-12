import std/[bitops, strformat]

proc bitSize(t: typedesc): int = sizeof(t) shl 3

proc lwb(n: SomeInteger): int =
  doAssert n != 0
  firstSetBit(n) - 1

proc upb(n: SomeInteger): int =
  doAssert n != 0
  bitSize(n.type) - countLeadingZeroBits(n) - 1


proc output[T: SomeInteger](mul: T) =
  echo &"For {T.bitSize} bits integers:"
  var e = 0
  var n = T(1)
  let lim = T.high div mul
  while true:
    echo &"{mul:>6}^{e} = {n:<19}   LSB: {lwb(n)}   MSB: {upb(n)}"
    if n > lim: break
    n *= mul
    inc e


output[uint32](42)
echo()
output[uint64](1302)
