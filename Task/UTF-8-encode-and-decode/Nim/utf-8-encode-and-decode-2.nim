import sequtils, strformat, strutils

const

  # First byte of a 2-byte encoding starts 110 and carries 5 bits of data.
  B2Lead = 0xC0 # 1100 0000
  B2Mask = 0x1F # 0001 1111

  # First byte of a 3-byte encoding starts 1110 and carries 4 bits of data.
  B3Lead = 0xE0 # 1110 0000
  B3Mask = 0x0F # 0000 1111

  # First byte of a 4-byte encoding starts 11110 and carries 3 bits of data.
  B4Lead = 0xF0 # 1111 0000
  B4Mask = 0x07 # 0000 0111

  # Non-first bytes start 10 and carry 6 bits of data.
  MbLead = 0x80 # 1000 0000
  MbMask = 0x3F # 0011 1111


type CodePoint = distinct int32


proc toUtf8(c: CodePoint): seq[byte] =
  let i = int32(c)
  result = if i <= 1 shl 7 - 1:
             @[byte(i)]
           elif i <= 1 shl 11 - 1:
             @[B2Lead or byte(i shr 6),
               MbLead or byte(i) and MbMask]
           elif i <= 1 shl  16 - 1:
             @[B3Lead or byte(i shr 12),
               MbLead or byte(i shr 6) and MbMask,
               MbLead or byte(i) and MbMask]
           else:
             @[B4Lead or byte(i shr 18),
               MbLead or byte(i shr 12) and MbMask,
               MbLead or byte(i shr 6) and MbMask,
               MbLead or byte(i) and MbMask]


proc toCodePoint(b: seq[byte]): CodePoint =
  let b0 = b[0].int32
  result = CodePoint(
    if b0 < 0x80: b0
    elif b0 < 0xE0: (b0 and B2Mask) shl 6 or b[1].int32 and MbMask
    elif b0 < 0xF0: (b0 and B3Mask) shl 12 or
                    (b[1].int32 and MbMask) shl 6 or b[2].int32 and MbMask
    else: (b0 and B4Mask) shl 18 or (b[1].int32 and MbMask) shl 12 or
          (b[2].int32 and MbMask) shl 6 or b[3].int32 and MbMask)


proc toString(s: seq[byte]): string =
  s.mapIt(chr(it)).join()


const UChars = [CodePoint(0x00041),
                CodePoint(0x000F6),
                CodePoint(0x00416),
                CodePoint(0x020AC),
                CodePoint(0x1D11E)]

echo "Character  Unicode  UTF-8 encoding (hex)"

for uchar in UChars:
  # Convert the code point to a sequence of bytes.
  let s = uchar.toUtf8
  # Convert back the sequence of bytes to a code point.
  let c = s.toCodePoint
  # Display.
  echo &"""{s.toString:>5}      U+{c.int.toHex(5)}  {s.map(toHex).join(" ")}"""
