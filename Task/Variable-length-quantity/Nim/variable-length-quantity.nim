import unsigned, strutils

proc toSeq(x: uint64): seq[uint8] =
  var x = x
  result = @[]
  var f = 0
  for i in countdown(9, 1):
    if (x and (127'u64 shl uint((i * 7)))) > 0'u64:
      f = i
      break
  for j in 0..f:
    result.add(uint8((x shr uint64((f - j) * 7)) and 127) or 128)

  result[f] = result[f] xor 128'u8

proc fromSeq(xs): uint64 =
  result = 0
  for x in xs:
    result = (result shl 7) or (x and 127)

for x in [0x7f'u64, 0x4000'u64, 0'u64, 0x3ffffe'u64, 0x1fffff'u64,
          0x200000'u64, 0x3311a1234df31413'u64]:
  let c = toSeq(x)
  echo "seq from $#: $# back: $#".format(x, c, fromSeq(c))
