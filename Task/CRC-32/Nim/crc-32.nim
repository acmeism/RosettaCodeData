import unsigned, strutils

type TCrc32* = uint32
const InitCrc32* = TCrc32(-1)

proc createCrcTable(): array[0..255, TCrc32] =
  for i in 0..255:
    var rem = TCrc32(i)
    for j in 0..7:
      if (rem and 1) > 0: rem = (rem shr 1) xor TCrc32(0xedb88320)
      else: rem = rem shr 1
    result[i] = rem

# Table created at compile time
const crc32table = createCrcTable()

proc crc32(s: string): TCrc32 =
  result = InitCrc32
  for c in s:
    result = (result shr 8) xor crc32table[(result and 0xff) xor ord(c)]
  result = not result

echo crc32("The quick brown fox jumps over the lazy dog").int64.toHex(8)
