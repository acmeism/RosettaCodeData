import bitops, sequtils, strutils


####################################################################################################
# Bitstring.

# Bit string used to represent an array of booleans.
type BitString = object
  len: Natural        # length in bits.
  values: seq[byte]   # Sequence containing the bits.


func initBitString(n: Natural): BitString =
  ## Return a new bit string of length "n" bits.
  result.len = n
  result.values.setLen((n + 7) shr 3)

template checkIndex(i, length: Natural) {.used.} =
  ## Check if index "i" is less than the array length.
  if i >= length:
    raise newException(IndexDefect, "index $1 not in 0 .. $2".format(i, length))

func `[]`(bs: BitString; i: Natural): bool =
  ## Return the value of bit at index "i" as a boolean.
  when compileOption("boundchecks"):
    checkIndex(i, bs.len)
  result = bs.values[i shr 3].testbit(i and 0x07)

func `[]=`(bs: var BitString; i: Natural; value: bool) =
  ## Set the bit at index "i" to the given value.
  when compileOption("boundchecks"):
    checkIndex(i, bs.len)
  if value: bs.values[i shr 3].setBit(i and 0x07)
  else: bs.values[i shr 3].clearBit(i and 0x07)

func `xor`(bs1, bs2: BitString): BitString =
  when compileOption("boundchecks"):
    if bs1.len != bs2.len:
      raise newException(ValueError, "uncompatible lengths")
  result = initBitString(bs1.len)
  for i in 0..result.values.high:
    result.values[i] = bs1.values[i] xor bs2.values[i]


####################################################################################################
# DES.

const

  PC1 = [57, 49, 41, 33, 25, 17,  9,
          1, 58, 50, 42, 34, 26, 18,
         10,  2, 59, 51, 43, 35, 27,
         19, 11,  3, 60, 52, 44, 36,
         63, 55, 47, 39, 31, 23, 15,
          7, 62, 54, 46, 38, 30, 22,
         14,  6, 61, 53, 45, 37, 29,
         21, 13,  5, 28, 20, 12,  4]

  PC2 = [14, 17, 11, 24,  1,  5,
          3, 28, 15,  6, 21, 10,
         23, 19, 12,  4, 26,  8,
         16,  7, 27, 20, 13,  2,
         41, 52, 31, 37, 47, 55,
         30, 40, 51, 45, 33, 48,
         44, 49, 39, 56, 34, 53,
         46, 42, 50, 36, 29, 32]

  IP = [58, 50, 42, 34, 26, 18, 10, 2,
        60, 52, 44, 36, 28, 20, 12, 4,
        62, 54, 46, 38, 30, 22, 14, 6,
        64, 56, 48, 40, 32, 24, 16, 8,
        57, 49, 41, 33, 25, 17,  9, 1,
        59, 51, 43, 35, 27, 19, 11, 3,
        61, 53, 45, 37, 29, 21, 13, 5,
        63, 55, 47, 39, 31, 23, 15, 7]

  E = [32,  1,  2,  3,  4,  5,
        4,  5,  6,  7,  8,  9,
        8,  9, 10, 11, 12, 13,
       12, 13, 14, 15, 16, 17,
       16, 17, 18, 19, 20, 21,
       20, 21, 22, 23, 24, 25,
       24, 25, 26, 27, 28, 29,
       28, 29, 30, 31, 32,  1]

  S = [[14,  4, 13,  1,  2, 15, 11,  8,  3, 10,  6, 12,  5,  9,  0,  7,
         0, 15,  7,  4, 14,  2, 13,  1, 10,  6, 12, 11,  9,  5,  3,  8,
         4,  1, 14,  8, 13,  6,  2, 11, 15, 12,  9,  7,  3, 10,  5,  0,
        15, 12,  8,  2,  4,  9,  1,  7,  5, 11,  3, 14, 10,  0,  6, 13],

       [15,  1,  8, 14,  6, 11,  3,  4,  9,  7,  2, 13, 12,  0,  5, 10,
         3, 13,  4,  7, 15,  2,  8, 14, 12,  0,  1, 10,  6,  9, 11,  5,
         0, 14,  7, 11, 10,  4, 13,  1,  5,  8, 12,  6,  9,  3,  2, 15,
        13,  8, 10,  1,  3, 15,  4,  2, 11,  6,  7, 12,  0,  5, 14,  9],

       [10,  0,  9, 14,  6,  3, 15,  5,  1, 13, 12,  7, 11,  4,  2,  8,
        13,  7,  0,  9,  3,  4,  6, 10,  2,  8,  5, 14, 12, 11, 15,  1,
        13,  6,  4,  9,  8, 15,  3,  0, 11,  1,  2, 12,  5, 10, 14,  7,
         1, 10, 13,  0,  6,  9,  8,  7,  4, 15, 14,  3, 11,  5,  2, 12],

       [ 7, 13, 14,  3,  0,  6,  9, 10,  1,  2,  8,  5, 11, 12,  4, 15,
        13,  8, 11,  5,  6, 15,  0,  3,  4,  7,  2, 12,  1, 10, 14,  9,
        10,  6,  9,  0, 12, 11,  7, 13, 15,  1,  3, 14,  5,  2,  8,  4,
         3, 15,  0,  6, 10,  1, 13,  8,  9,  4,  5, 11, 12,  7,  2, 14],

       [ 2, 12,  4,  1,  7, 10, 11,  6,  8,  5,  3, 15, 13,  0, 14,  9,
        14, 11,  2, 12,  4,  7, 13,  1,  5,  0, 15, 10,  3,  9,  8,  6,
         4,  2,  1, 11, 10, 13,  7,  8, 15,  9, 12,  5,  6,  3,  0, 14,
        11,  8, 12,  7,  1, 14,  2, 13,  6, 15,  0,  9, 10,  4,  5,  3],

       [12,  1, 10, 15,  9,  2,  6,  8,  0, 13,  3,  4, 14,  7,  5, 11,
        10, 15,  4,  2,  7, 12,  9,  5,  6,  1, 13, 14,  0, 11,  3,  8,
         9, 14, 15,  5,  2,  8, 12,  3,  7,  0,  4, 10,  1, 13, 11,  6,
         4,  3,  2, 12,  9,  5, 15, 10, 11, 14,  1,  7,  6,  0,  8, 13],

       [ 4, 11,  2, 14, 15,  0,  8, 13,  3, 12,  9,  7,  5, 10,  6,  1,
        13,  0, 11,  7,  4,  9,  1, 10, 14,  3,  5, 12,  2, 15,  8,  6,
         1,  4, 11, 13, 12,  3,  7, 14, 10, 15,  6,  8,  0,  5,  9,  2,
         6, 11, 13,  8,  1,  4, 10,  7,  9,  5,  0, 15, 14,  2,  3, 12],

       [13,  2,  8,  4,  6, 15, 11,  1, 10,  9,  3, 14,  5,  0, 12,  7,
         1, 15, 13,  8, 10,  3,  7,  4, 12,  5,  6, 11,  0, 14,  9,  2,
         7, 11,  4,  1,  9, 12, 14,  2,  0,  6, 10, 13, 15,  3,  5,  8,
         2,  1, 14,  7,  4, 10,  8, 13, 15, 12,  9,  0,  3,  5,  6, 11]]

  P = [16,  7, 20, 21,
       29, 12, 28, 17,
        1, 15, 23, 26,
        5, 18, 31, 10,
        2,  8, 24, 14,
       32, 27,  3,  9,
       19, 13, 30,  6,
       22, 11,  4, 25]

  IP2 = [40, 8, 48, 16, 56, 24, 64, 32,
         39, 7, 47, 15, 55, 23, 63, 31,
         38, 6, 46, 14, 54, 22, 62, 30,
         37, 5, 45, 13, 53, 21, 61, 29,
         36, 4, 44, 12, 52, 20, 60, 28,
         35, 3, 43, 11, 51, 19, 59, 27,
         34, 2, 42, 10, 50, 18, 58, 26,
         33, 1, 41,  9, 49, 17, 57, 25]

  Shifts = [1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1]


func toBitString(byteArr: openArray[byte]): BitString =
  result = initBitString(8 * byteArr.len)
  for i in 0..byteArr.high:
    result[8 * i]     = bool(byteArr[i] and 128)
    result[8 * i + 1] = bool(byteArr[i] and 64)
    result[8 * i + 2] = bool(byteArr[i] and 32)
    result[8 * i + 3] = bool(byteArr[i] and 16)
    result[8 * i + 4] = bool(byteArr[i] and 8)
    result[8 * i + 5] = bool(byteArr[i] and 4)
    result[8 * i + 6] = bool(byteArr[i] and 2)
    result[8 * i + 7] = bool(byteArr[i] and 1)


func toByteArray(bitStr: BitString): seq[byte] =
  result.setLen(bitStr.len div 8)
  for i in 0..result.high:
    result[i] = byte(bitStr[8 * i])     shl 7 or
                byte(bitStr[8 * i + 1]) shl 6 or
                byte(bitStr[8 * i + 2]) shl 5 or
                byte(bitStr[8 * i + 3]) shl 4 or
                byte(bitStr[8 * i + 4]) shl 3 or
                byte(bitStr[8 * i + 5]) shl 2 or
                byte(bitStr[8 * i + 6]) shl 1 or
                byte(bitStr[8 * i + 7])


func shiftLeft(input: BitString; n, len: Natural; output: var BitString) =
  for i in 0..<len: output[i] = input[i]
  for _ in 1..n:
    let temp = output[0]
    for i in 1..<len:
      output[i - 1] = output[i]
    output[len - 1] = temp


func f(r, ks: BitString): BitString =

  # Permute 'r' using table E.
  var er = initBitString(48)
  for i in 0..47: er[i] = r[E[i] - 1]

  # Xor 'er' with 'ks' and store back into 'er'.
  er = er xor ks

  # Process 'er' six bits at a time and store resulting four bits in 'sr'.
  var sr = initBitString(32)
  for i in 0..7:
    let j = i * 6
    var b: array[6, int]
    for k in 0..5: b[k] = ord(er[j + k])
    let row = 2 * b[0] + b[5]
    let col = 8 * b[1] + 4 * b[2] + 2 * b[3] + b[4]
    var m = S[i][row * 16 + col]  # Apply table S.
    var n = 1
    while m > 0:
      let p = m and 1
      sr[(i + 1) * 4 - n] = p == 1
      m = m shr 1
      inc n

  # Permute 'sr' using table P.
  result = initBitString(32)
  for i in 0..31: result[i] = sr[P[i] - 1]


func processMessage(message: openArray[byte]; ks: openArray[BitString]): seq[byte] =

  # Permute 'message' using table IP.
  let m = message.toBitString
  var mp = initBitString(64)
  for i in 0..63: mp[i] = m[IP[i] - 1]

  # Split 'mp' in half and process the resulting series of 'left' and 'right'.
  var left, right = initBitString(32)
  for i in 0..31:
    left[i] = mp[i]
    right[i] = mp[i + 32]
  for i in 1..16:
    left = left xor f(right, ks[i])
    swap left, right

  # Amalgamate 'right' and 'left' (in that order) into 'e'.
  var e = initBitString(64)
  for i in 0..31:
    e[i] = right[i]
  for i in 32..63:
    e[i] = left[i - 32]

  # Permute 'e' using table IP2 ad return result as a byte array.
  var ep = initBitString(64)
  for i in 0..63: ep[i] = e[IP2[i] - 1]
  result = ep.toByteArray()


func getSubKeys(key: openArray[byte]): seq[BitString] =
  assert key.len == 8, "incorrect key size."

  let k = key.toBitString

  # Permute 'key' using table PC1.
  var kp = initBitString(56)
  for i in 0..55: kp[i] = k[PC1[i] - 1]

  # Split 'kp' in half and process the resulting series of 'c' and 'd'.
  var c = newSeqWith(18, initBitString(56))
  var d = newSeqWith(18, initBitString(28))
  for i in 0..27:
    c[0][i] = kp[i]
    d[0][i] = kp[i + 28]
  for i in 1..16:
    c[i - 1].shiftLeft(SHIFTS[i - 1], 28, c[i])
    d[i - 1].shiftLeft(SHIFTS[i - 1], 28, d[i])

  # Merge 'd' into 'c'.
  for i in 1..16:
    for j in 28..55:
      c[i][j] = d[i][j - 28]

  # Allocate the sub-keys and store them in result.
  result = newSeqWith(17, initBitString(48))

  # Permute 'c' using table PC2.
  for i in 1..16:
    for j in 0..47:
      result[i][j] = c[i][PC2[j] - 1]


func encrypt(key, message: openArray[byte]): seq[byte] =
  let ks = key.getSubKeys()
  var m = @message

  # Pad the message so there are 8 byte groups.
  let padByte = byte(8 - (m.len and 7))
  for _ in 1u..padByte: m.add padByte

  for i in 0..<(m.len shr 3):
    let j = i * 8
    result.add processMessage(m[j..j+7], ks)


func decrypt(key, encoded: openArray[byte]): seq[byte] =
  var ks = key.getSubKeys()
  # Reverse the subkeys.
  for i in 1..8:
    swap ks[i], ks[17 - i]

  for i in 0..<(encoded.len shr 3):
    let j = i * 8
    result.add processMessage(encoded[j..j+7], ks)

  # Remove the padding bytes from the decoded message.
  let padByte = int(result[^1])
  result.setLen(result.len - padByte)


when isMainModule:

  const Keys = [[byte 0x13, 0x34, 0x57, 0x79, 0x9B, 0xBC, 0xDF, 0xF1],
                [byte 0x0E, 0x32, 0x92, 0x32, 0xEA, 0x6D, 0x0D, 0x73],
                [byte 0x0E, 0x32, 0x92, 0x32, 0xEA, 0x6D, 0x0D, 0x73]
               ]

  const Messages = [@[byte 0x01, 0x23, 0x45, 0x67, 0x89, 0xAB, 0xCD, 0xEF],
                    @[byte 0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87, 0x87],
                    @[byte 0x59, 0x6F, 0x75, 0x72, 0x20, 0x6C, 0x69, 0x70,
                           0x73, 0x20, 0x61, 0x72, 0x65, 0x20, 0x73, 0x6D,
                           0x6F, 0x6F, 0x74, 0x68, 0x65, 0x72, 0x20, 0x74,
                           0x68, 0x61, 0x6E, 0x20, 0x76, 0x61, 0x73, 0x65,
                           0x6C, 0x69, 0x6E, 0x65, 0x0D, 0x0A]
                   ]

  func toHex(s: openArray[byte]): string = s.mapIt(it.toHex).join()

  assert Keys.len == Messages.len

  for i in 0..Messages.high:
    echo "Key:     ", Keys[i].toHex()
    echo "Message: ", Messages[i].toHex()
    let encoded = encrypt(Keys[i], Messages[i])
    echo "Encoded: ", encoded.toHex()
    let decoded = decrypt(Keys[i], encoded)
    echo "Decoded: ", decoded.toHex()
    echo()
