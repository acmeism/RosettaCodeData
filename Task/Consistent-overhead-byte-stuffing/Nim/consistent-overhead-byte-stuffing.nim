import std/[sequtils, strformat, strutils]


proc cobsEncode(data: seq[byte]): seq[byte] =

  result = @[0]
  var codeIndex = 0
  var code: byte = 1
  var finalCode = true

  for b in data:
    finalCode = true
    if b != 0:
      result.add b
      inc code
    if b == 0 or code == 0xff:
      if code == 0xff:
        finalCode = false
      result[codeIndex] = code
      code = 1
      result.add 0
      codeIndex = result.high

  if finalCode:
    assert result[codeIndex] == 0
    result[codeIndex] = code

  if result[^1] != 0:
    result.add 0


proc cobsDecode(encoded: seq[byte]): seq[byte] =

  var code: byte = 0xff
  var blck: byte = 0
  for i in 0..(encoded.len - 2):
    let b = encoded[i]
    if blck != 0:
      result.add b
    else:
      if code != 0xff:
        result.add 0
      blck = b
      code = b
      if code == 0: break
    dec blck

const Examples = [
    (@[0x00u8], @[0x01u8, 0x01, 0x00]),
    (@[0x00, 0x00], @[0x01, 0x01, 0x01, 0x00]),
    (@[0x00, 0x11, 0x00], @[0x01, 0x02, 0x11, 0x01, 0x00]),
    (@[0x11, 0x22, 0x00, 0x33], @[0x03, 0x11, 0x22, 0x02, 0x33, 0x00]),
    (@[0x11, 0x22, 0x33, 0x44], @[0x05, 0x11, 0x22, 0x33, 0x44, 0x00]),
    (@[0x11, 0x00, 0x00, 0x00], @[0x02, 0x11, 0x01, 0x01, 0x01, 0x00]),
    (toSeq(0x01u8..0xFEu8), 0xFFu8 & toSeq(0x01u8..0xFEu8) & 0x00),
    (toSeq(0x00u8..0xFEu8), @[0x01u8, 0xFFu8] & toSeq(0x01u8..0xFEu8) & 0x00),
    (toSeq(0x01u8..0xFFu8), 0xFFu8 & toSeq(0x01u8..0xFEu8) & 0x02 & 0xFF & 0x00),
    (toSeq(0x02u8..0xFFu8) & 0x00, 0xFFu8 & toSeq(0x02u8..0xFFu8) & 0x01 & 0x01 & 0x00),
    (toSeq(0x03u8..0xFFu8) & 0x00 & 0x01, 0xFEu8 & toSeq(0x03u8..0xFFu8) & 0x02 & 0x01 & 0x00)]


proc prettyHex(bytes: seq[byte]; m, n: int): string =

  template toHex(bytes: seq[byte]): string =
    bytes.mapIt(it.toHex()).join(" ").toUpperAscii()

  result = if bytes.len < m: bytes.toHex()
           else: &"{bytes[0..<n].toHex()} ... {bytes[^n..^1].toHex()}"


for (data, expected) in Examples:
  let encoded = data.cobsEncode()
  doAssert encoded == expected
  doAssert encoded.cobsDecode() == data
  echo &"{data.prettyHex(5, 3):<23} -> {encoded.prettyHex(7, 4):<33}"
