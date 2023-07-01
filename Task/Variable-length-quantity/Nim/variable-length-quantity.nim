import strformat

proc toSeq(x: uint64): seq[uint8] =
  var x = x
  var f = 0u64
  for i in countdown(9u64, 1):
    if (x and 127'u64 shl (i * 7)) > 0:
      f = i
      break
  for j in 0u64..f:
    result.add uint8((x shr ((f - j) * 7)) and 127) or 128

  result[f] = result[f] xor 128'u8

proc fromSeq(xs: openArray[uint8]): uint64 =
  for x in xs:
    result = (result shl 7) or (x and 127)

for x in [0x7f'u64, 0x4000'u64, 0'u64, 0x3ffffe'u64, 0x1fffff'u64,
          0x200000'u64, 0x3311a1234df31413'u64]:
  let c = toSeq(x)
  echo &"seq from {x}: {c} back: {fromSeq(c)}"
