import "./fmt" for Fmt

var k = [
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee ,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501 ,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be ,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821 ,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa ,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8 ,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed ,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a ,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c ,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70 ,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05 ,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665 ,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039 ,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1 ,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1 ,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
]

var r = [
    7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,
    5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20,
    4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23,
    6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
]

var leftRotate = Fn.new { |x, c| (x << c) | (x >> (32 - c)) }

var toBytes = Fn.new { |val|
    var bytes = List.filled(4, 0)
    bytes[0] = val         & 255
    bytes[1] = (val >> 8)  & 255
    bytes[2] = (val >> 16) & 255
    bytes[3] = (val >> 24) & 255
    return bytes
}

var toInt = Fn.new { |bytes| bytes[0] | bytes[1] << 8 | bytes[2] << 16 | bytes[3] << 24 }

var md5 = Fn.new { |initMsg|
    var h0 = 0x67452301
    var h1 = 0xefcdab89
    var h2 = 0x98badcfe
    var h3 = 0x10325476
    var initBytes = initMsg.bytes
    var initLen = initBytes.count
    var newLen = initLen + 1
    while (newLen % 64 != 56) newLen = newLen + 1
    var msg = List.filled(newLen + 8, 0)
    for (i in 0...initLen) msg[i] = initBytes[i]
    msg[initLen] = 0x80 // remaining bytes already 0
    var lenBits = toBytes.call(initLen * 8)
    for (i in newLen...newLen+4) msg[i] = lenBits[i-newLen]
    var extraBits = toBytes.call(initLen >> 29)
    for (i in newLen+4...newLen+8) msg[i] = extraBits[i-newLen-4]
    var offset = 0
    var w = List.filled(16, 0)
    while (offset < newLen) {
        for (i in 0...16) w[i] = toInt.call(msg[offset+i*4...offset + i*4 + 4])
        var a = h0
        var b = h1
        var c = h2
        var d = h3
        var f
        var g
        for (i in 0...64) {
            if (i < 16) {
                f = (b & c) | ((~b) & d)
                g = i
            } else if (i < 32) {
                f = (d & b) | ((~d) & c)
                g = (5*i + 1) % 16
            } else if (i < 48) {
                f = b ^ c ^ d
                g = (3*i + 5) % 16
            } else {
                f = c ^ (b | (~d))
                g = (7*i) % 16
            }
            var temp = d
            d = c
            c = b
            b = b + leftRotate.call((a + f + k[i] + w[g]), r[i])
            a = temp
        }
        h0 = h0 + a
        h1 = h1 + b
        h2 = h2 + c
        h3 = h3 + d
        offset = offset + 64
    }
    var digest = List.filled(16, 0)
    var dBytes = toBytes.call(h0)
    for (i in 0...4) digest[i] = dBytes[i]
    dBytes = toBytes.call(h1)
    for (i in 0...4) digest[i+4] = dBytes[i]
    dBytes = toBytes.call(h2)
    for (i in 0...4) digest[i+8] = dBytes[i]
    dBytes = toBytes.call(h3)
    for (i in 0...4) digest[i+12] = dBytes[i]
    return digest
}

var strings = [
    "",
    "a",
    "abc",
    "message digest",
    "abcdefghijklmnopqrstuvwxyz",
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
    "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
]

for (s in strings) {
    var digest = md5.call(s)
    Fmt.print("0x$s <== '$0s'", Fmt.v("xz", 2, digest, 0, "", ""), s)
}
