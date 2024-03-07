import "./fmt" for Fmt

var toBytes = Fn.new { |val|
    var bytes = List.filled(4, 0)
    bytes[0] = val         & 255
    bytes[1] = (val >> 8)  & 255
    bytes[2] = (val >> 16) & 255
    bytes[3] = (val >> 24) & 255
    return bytes
}

var toInt = Fn.new { |bytes| bytes[0] | bytes[1] << 8 | bytes[2] << 16 | bytes[3] << 24 }

var md4 = Fn.new { |initMsg|
    var f = Fn.new { |x, y, z| (x & y) | (~x & z) }
    var g = Fn.new { |x, y, z| (x & y) | (x & z) | (y & z) }
    var h = Fn.new { |x, y, z| x ^ y ^ z }
    var r = Fn.new { |v, s| (v << s) | (v >> (32 - s)) }

    var a = 0x67452301
    var b = 0xefcdab89
    var c = 0x98badcfe
    var d = 0x10325476
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
    var x = List.filled(16, 0)
    while (offset < newLen) {
        for (i in 0...16) x[i] = toInt.call(msg[offset+i*4...offset + i*4 + 4])
        var a2 = a
        var b2 = b
        var c2 = c
        var d2 = d
        for (i in [0, 4, 8, 12]) {
            a = r.call(a + f.call(b, c, d) + x[i+0],  3)
            d = r.call(d + f.call(a, b, c) + x[i+1],  7)
            c = r.call(c + f.call(d, a, b) + x[i+2], 11)
            b = r.call(b + f.call(c, d, a) + x[i+3], 19)
        }
        for (i in 0..3) {
            a = r.call(a + g.call(b, c, d) + x[i+0]  + 0x5a827999,  3)
            d = r.call(d + g.call(a, b, c) + x[i+4]  + 0x5a827999,  5)
            c = r.call(c + g.call(d, a, b) + x[i+8]  + 0x5a827999,  9)
            b = r.call(b + g.call(c, d, a) + x[i+12] + 0x5a827999, 13)
        }
        for (i in [0, 2, 1, 3]) {
            a = r.call(a + h.call(b, c, d) + x[i+0]  + 0x6ed9eba1,  3)
            d = r.call(d + h.call(a, b, c) + x[i+8]  + 0x6ed9eba1,  9)
            c = r.call(c + h.call(d, a, b) + x[i+4]  + 0x6ed9eba1, 11)
            b = r.call(b + h.call(c, d, a) + x[i+12] + 0x6ed9eba1, 15)
        }
        a = a + a2
        b = b + b2
        c = c + c2
        d = d + d2
        offset = offset + 64
    }
    var digest = List.filled(16, 0)
    var dBytes = toBytes.call(a)
    for (i in 0...4) digest[i] = dBytes[i]
    dBytes = toBytes.call(b)
    for (i in 0...4) digest[i+4] = dBytes[i]
    dBytes = toBytes.call(c)
    for (i in 0...4) digest[i+8] = dBytes[i]
    dBytes = toBytes.call(d)
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
    "12345678901234567890123456789012345678901234567890123456789012345678901234567890",
    "Rosetta Code"
]

for (s in strings) {
    var digest = md4.call(s)
    Fmt.print("$s <== '$0s'", Fmt.v("xz", 2, digest, 0, "", ""), s)
}
