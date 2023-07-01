import Foundation

let shift : [UInt32] = [7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21]
let table: [UInt32] = (0 ..< 64).map { UInt32(0x100000000 * abs(sin(Double($0 + 1)))) }

func md5(var message: [UInt8]) -> [UInt8] {
  var messageLenBits = UInt64(message.count) * 8
  message.append(0x80)
  while message.count % 64 != 56 {
    message.append(0)
  }

  var lengthBytes = [UInt8](count: 8, repeatedValue: 0)
  UnsafeMutablePointer<UInt64>(lengthBytes).memory = messageLenBits.littleEndian
  message += lengthBytes

  var a : UInt32 = 0x67452301
  var b : UInt32 = 0xEFCDAB89
  var c : UInt32 = 0x98BADCFE
  var d : UInt32 = 0x10325476
  for chunkOffset in stride(from: 0, to: message.count, by: 64) {
    let chunk = UnsafePointer<UInt32>(UnsafePointer<UInt8>(message) + chunkOffset)
    let originalA = a
    let originalB = b
    let originalC = c
    let originalD = d
    for j in 0 ..< 64 {
      var f : UInt32 = 0
      var bufferIndex = j
      let round = j >> 4
      switch round {
      case 0:
        f = (b & c) | (~b & d)
      case 1:
        f = (b & d) | (c & ~d)
        bufferIndex = (bufferIndex*5 + 1) & 0x0F
      case 2:
        f = b ^ c ^ d
        bufferIndex = (bufferIndex*3 + 5) & 0x0F
      case 3:
        f = c ^ (b | ~d)
        bufferIndex = (bufferIndex * 7) & 0x0F
      default:
        assert(false)
      }
      let sa = shift[(round<<2)|(j&3)]
      let tmp = a &+ f &+ UInt32(littleEndian: chunk[bufferIndex]) &+ table[j]
      a = d
      d = c
      c = b
      b = b &+ (tmp << sa | tmp >> (32-sa))
    }
    a = a &+ originalA
    b = b &+ originalB
    c = c &+ originalC
    d = d &+ originalD
  }

  var result = [UInt8](count: 16, repeatedValue: 0)
  for (i, n) in enumerate([a, b, c, d]) {
    UnsafeMutablePointer<UInt32>(result)[i] = n.littleEndian
  }
  return result
}

func toHexString(bytes: [UInt8]) -> String {
  return "".join(bytes.map { String(format:"%02x", $0) })
}

for (hashCode, string) in [
  ("d41d8cd98f00b204e9800998ecf8427e", ""),
  ("0cc175b9c0f1b6a831c399e269772661", "a"),
  ("900150983cd24fb0d6963f7d28e17f72", "abc"),
  ("f96b697d7cb7938d525a2f31aaf161d0", "message digest"),
  ("c3fcd3d76192e4007dfb496cca67e13b", "abcdefghijklmnopqrstuvwxyz"),
  ("d174ab98d277d9f5a5611c2c9f419d9f",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"),
  ("57edf4a22be3c955ac49da2e2107b67a", "12345678901234567890" +
    "123456789012345678901234567890123456789012345678901234567890")] {
      println(hashCode)
      println(toHexString(md5(Array(string.utf8))))
      println()
}
