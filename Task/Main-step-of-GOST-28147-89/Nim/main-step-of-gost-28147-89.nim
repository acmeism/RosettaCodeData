import sequtils, strutils

const
  K1 = [byte  4, 10,  9,  2, 13,  8,  0, 14,  6, 11,  1, 12,  7, 15,  5,  3]
  K2 = [byte 14, 11,  4, 12,  6, 13, 15, 10,  2,  3,  8,  1,  0,  7,  5,  9]
  K3 = [byte  5,  8,  1, 13, 10,  3,  4,  2, 14, 15, 12,  7,  6,  0,  9, 11]
  K4 = [byte  7, 13, 10,  1,  0,  8,  9, 15, 14,  4,  6, 12, 11,  2,  5,  3]
  K5 = [byte  6, 12,  7,  1,  5, 15, 13,  8,  4, 10,  9, 14,  0,  3, 11,  2]
  K6 = [byte  4, 11, 10,  0,  7,  2,  1, 13,  3,  6,  8,  5,  9, 12, 15, 14]
  K7 = [byte 13, 11,  4,  1,  3, 15,  5,  9,  0, 10, 14,  7,  6,  8,  2, 12]
  K8 = [byte  1, 15, 13,  0,  5,  7, 10,  4,  9,  2,  3, 14,  6, 11,  8, 12]


proc kboxInit: tuple[k87, k65, k43, k21: array[256, byte]] {.compileTime.} =
  for i in 0 .. 255:
    result.k87[i] = K8[i shr 4] shl 4 or K7[i and 15]
    result.k65[i] = K6[i shr 4] shl 4 or K5[i and 15]
    result.k43[i] = K4[i shr 4] shl 4 or K3[i and 15]
    result.k21[i] = K2[i shr 4] shl 4 or K1[i and 15]

const (K87, K65, K43, K21) = kboxInit()

template rol(x: uint32; n: typed): uint32 =
  x shl n or x shr (32 - n)

proc f(x: uint32): uint32 =
  let x = K87[x shr 24 and 255].uint32 shl 24 or K65[x shr 16 and 255].uint32 shl 16 or
          K43[x shr 8 and 255].uint32 shl 8 or K21[x and 255].uint32
  result = x.rol(11)

proc mainStep(input: array[8, byte]; key: array[4, byte]): array[8, byte] =
  let input32 = cast[array[2, uint32]](input)
  let key = cast[uint32](key)
  let val = f(key + input32[0]) xor input32[1]
  result[0..3] = cast[array[4, byte]](val)
  result[4..7] = input[0..3]

when isMainModule:
  const
    Input = [byte 0x21, 0x04, 0x3B, 0x04, 0x30, 0x04, 0x32, 0x04]
    Key = [byte 0xF9, 0x04, 0xC1, 0xE2]

  let output = mainStep(Input, Key)
  echo mapIt(output, it.toHex).join(" ")
