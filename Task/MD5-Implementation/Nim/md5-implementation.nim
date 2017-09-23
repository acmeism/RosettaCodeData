import sequtils

const
  ChunkSize = 512 div 8
  SumSize = 128 div 8

proc extractChunk(msg : seq[uint8], chunk: var openarray[uint32], offset: int) =
  var
    srcIndex = offset

  for dstIndex in 0 .. < 16:
    chunk[dstIndex] = 0
    for ii in 0 .. < 4:
      chunk[dstIndex] = chunk[dstIndex] shr 8
      chunk[dstIndex] = chunk[dstIndex] or (msg[srcIndex].uint32 shl 24)
      srcIndex.inc

proc leftRotate(val: uint32, shift: int) : uint32 =
  result = (val shl shift) or (val shr (32 - shift))

proc md5Sum(msg : seq[uint8]) : array[SumSize, uint8] =
  const
    s : array[ChunkSize, int] =
          [ 7, 12, 17, 22,  7, 12, 17, 22,
            7, 12, 17, 22,  7, 12, 17, 22,
            5,  9, 14, 20,  5,  9, 14, 20,
            5,  9, 14, 20,  5,  9, 14, 20,
            4, 11, 16, 23,  4, 11, 16, 23,
            4, 11, 16, 23,  4, 11, 16, 23,
            6, 10, 15, 21,  6, 10, 15, 21,
            6, 10, 15, 21,  6, 10, 15, 21 ]

    K : array[ChunkSize, uint32] =
          [ 0xd76aa478'u32, 0xe8c7b756'u32, 0x242070db'u32, 0xc1bdceee'u32,
            0xf57c0faf'u32, 0x4787c62a'u32, 0xa8304613'u32, 0xfd469501'u32,
            0x698098d8'u32, 0x8b44f7af'u32, 0xffff5bb1'u32, 0x895cd7be'u32,
            0x6b901122'u32, 0xfd987193'u32, 0xa679438e'u32, 0x49b40821'u32,
            0xf61e2562'u32, 0xc040b340'u32, 0x265e5a51'u32, 0xe9b6c7aa'u32,
            0xd62f105d'u32, 0x02441453'u32, 0xd8a1e681'u32, 0xe7d3fbc8'u32,
            0x21e1cde6'u32, 0xc33707d6'u32, 0xf4d50d87'u32, 0x455a14ed'u32,
            0xa9e3e905'u32, 0xfcefa3f8'u32, 0x676f02d9'u32, 0x8d2a4c8a'u32,
            0xfffa3942'u32, 0x8771f681'u32, 0x6d9d6122'u32, 0xfde5380c'u32,
            0xa4beea44'u32, 0x4bdecfa9'u32, 0xf6bb4b60'u32, 0xbebfbc70'u32,
            0x289b7ec6'u32, 0xeaa127fa'u32, 0xd4ef3085'u32, 0x04881d05'u32,
            0xd9d4d039'u32, 0xe6db99e5'u32, 0x1fa27cf8'u32, 0xc4ac5665'u32,
            0xf4292244'u32, 0x432aff97'u32, 0xab9423a7'u32, 0xfc93a039'u32,
            0x655b59c3'u32, 0x8f0ccc92'u32, 0xffeff47d'u32, 0x85845dd1'u32,
            0x6fa87e4f'u32, 0xfe2ce6e0'u32, 0xa3014314'u32, 0x4e0811a1'u32,
            0xf7537e82'u32, 0xbd3af235'u32, 0x2ad7d2bb'u32, 0xeb86d391'u32 ]


  # Pad with 1-bit, and fill with 0's up to 448 bits mod 512
  var paddedMsgSize = msg.len + 1
  var remain = (msg.len + 1) mod ChunkSize
  if remain > (448 div 8):
    paddedMsgSize += ChunkSize - remain + (448 div 8)
  else:
    paddedMsgSize += (448 div 8) - remain

  var paddingSize = paddedMsgSize - msg.len
  var padding = newSeq[uint8](paddingSize)
  padding[0] = 0x80

  # Pad with number of *bits* in original message, little-endian
  var sizePadding = newSeq[uint8](8)
  var size = msg.len * 8
  for ii in 0 .. < 4:
    sizePadding[ii] = uint8(size and 0xff)
    size = size shr 8

  var paddedMsg = concat(msg, padding, sizePadding)

  var accum = [ 0x67452301'u32, 0xefcdab89'u32, 0x98badcfe'u32, 0x10325476'u32 ]

  for offset in countup(0, paddedMsg.len - 1, ChunkSize):
    var A = accum[0]
    var B = accum[1]
    var C = accum[2]
    var D = accum[3]
    var F : uint32
    var g : int
    var M : array[16, uint32]
    var dTemp : uint32

    extractChunk(paddedMsg, M, offset)

    # This is pretty much the same as Wikipedia's MD5 entry
    for ii in 0 .. 63:
      if ii <= 15:
        F = (B and C) or ((not B) and D)
        g = ii

      elif ii <= 31:
        F = (D and B) or ((not D) and C)
        g = (5 * ii + 1) mod 16

      elif ii <= 47:
        F = B xor C xor D
        g = (3 * ii + 5) mod 16

      else:
        F = C xor (B or (not D))
        g = (7 * ii) mod 16

      dTemp = D
      D = C
      C = B
      B = B + leftRotate((A + F + K[ii] + M[g]), s[ii])
      A = dTemp

    accum[0] += A
    accum[1] += B
    accum[2] += C
    accum[3] += D

  # Convert four 32-bit accumulators to 16 byte array, little-endian
  var dstIdx : int
  for acc in accum:
    var tmp = acc

    for ii in 0 .. < 4:
      result[dstIdx] = uint8(tmp and 0xff)
      tmp = tmp shr 8
      dstIdx.inc

# Only needed to convert from string to uint8 sequence
iterator items * (str : string) : uint8 =
  for ii in 0 .. < len(str):
    yield str[ii].uint8

proc main =
  var msg = ""
  var sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0xD4'u8, 0x1D, 0x8C, 0xD9, 0x8F, 0x00, 0xB2, 0x04,
                  0xE9, 0x80, 0x09, 0x98, 0xEC, 0xF8, 0x42, 0x7E ] )

  msg = "The quick brown fox jumps over the lazy dog"
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0x9E'u8, 0x10, 0x7D, 0x9D, 0x37, 0x2B, 0xB6, 0x82,
                  0x6B, 0xD8, 0x1D, 0x35, 0x42, 0xA4, 0x19, 0xD6 ] )

  msg = "The quick brown fox jumps over the lazy dog."
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0xE4'u8, 0xD9, 0x09, 0xC2, 0x90, 0xD0, 0xFB, 0x1C,
                 0xA0, 0x68, 0xFF, 0xAD, 0xDF, 0x22, 0xCB, 0xD0 ])


  # Message size around magic 512 bits
  msg = "01234567890123456789012345678901234567890123456789012345678901234"
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0xBE'u8, 0xB9, 0xF4, 0x8B, 0xC8, 0x02, 0xCA, 0x5C,
                  0xA0, 0x43, 0xBC, 0xC1, 0x5E, 0x21, 0x9A, 0x5A ])

  msg = "0123456789012345678901234567890123456789012345678901234567890123"
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0x7F'u8, 0x7B, 0xFD, 0x34, 0x87, 0x09, 0xDE, 0xEA,
                  0xAC, 0xE1, 0x9E, 0x3F, 0x53, 0x5F, 0x8C, 0x54 ])

  msg = "012345678901234567890123456789012345678901234567890123456789012"
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0xC5'u8, 0xE2, 0x56, 0x43, 0x7E, 0x75, 0x80, 0x92,
                  0xDB, 0xFE, 0x06, 0x28, 0x3E, 0x48, 0x90, 0x19 ])


  # Message size around magic 448 bits
  msg = "01234567890123456789012345678901234567890123456789012345"
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0x8A'u8, 0xF2, 0x70, 0xB2, 0x84, 0x76, 0x10, 0xE7,
                  0x42, 0xB0, 0x79, 0x1B, 0x53, 0x64, 0x8C, 0x09 ])

  msg = "0123456789012345678901234567890123456789012345678901234"
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0x6E'u8, 0x7A, 0x4F, 0xC9, 0x2E, 0xB1, 0xC3, 0xF6,
                  0xE6, 0x52, 0x42, 0x5B, 0xCC, 0x8D, 0x44, 0xB5 ])

  msg = "012345678901234567890123456789012345678901234567890123"
  sum = md5Sum(toSeq(msg.items()))
  assert(sum == [ 0x3D'u8, 0xFF, 0x83, 0xC8, 0xFA, 0xDD, 0x26, 0x37,
                  0x0D, 0x5B, 0x09, 0x84, 0x09, 0x64, 0x44, 0x57 ])

main()
