import std/strutils

type Bcd64 = distinct uint64

func `+`(a, b: Bcd64): Bcd64 =
  let t1 = a.uint64 + 0x0666_6666_6666_6666u64
  let t2 = t1 + b.uint64
  let t3 = t1 xor b.uint64
  let t4 = not(t2 xor t3) and 0x1111_1111_1111_1110u64
  let t5 = (t4 shr 2) or (t4 shr 3)
  result = Bcd64(t2 - t5)

func `-`(a: Bcd64): Bcd64 =
  ## Return 10's complement.
  let t1 = cast[uint64](-cast[int64](a))
  let t2 = t1 + 0xFFFF_FFFF_FFFF_FFFFu64
  let t3 = t2 xor 1
  let t4 = not(t2 xor t3) and 0x1111_1111_1111_1110u64
  let t5 = (t4 shr 2) or (t4 shr 3)
  result = Bcd64(t1 - t5)

func `-`(a, b: Bcd64): Bcd64 =
  a + (-b)

func `$`(n: Bcd64): string =
  var s = n.uint64.toHex
  var i = 0
  while i < s.len - 1 and s[i] == '0':
    inc i
  result = "0x" & s[i..^1]

const One = Bcd64(0x01u64)
echo "$1 + $2 = $3".format(Bcd64(0x19), One, Bcd64(0x19) + One)
echo "$1 - $2 = $3".format(Bcd64(0x30), One, Bcd64(0x30) - One)
echo "$1 + $2 = $3".format(Bcd64(0x99), One, Bcd64(0x99) + One)
