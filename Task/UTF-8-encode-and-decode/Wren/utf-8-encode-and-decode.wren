import "/fmt" for Fmt

var utf8_encode = Fn.new { |cp| String.fromCodePoint(cp).bytes.toList }

var utf8_decode = Fn.new { |b|
    var mbMask = 0x3f // non-first bytes start 10 and carry 6 bits of data
    var b0 = b[0]
    if (b0 < 0x80) {
        return b0
    } else if (b0 < 0xe0) {
        var b2Mask = 0x1f // first byte of a 2-byte encoding starts 110 and carries 5 bits of data
        return (b0 & b2Mask) <<  6 | (b[1] & mbMask)
    } else if (b0 < 0xf0) {
        var b3Mask = 0x0f // first byte of a 3-byte encoding starts 1110 and carries 4 bits of data
        return (b0 & b3Mask) << 12 | (b[1] & mbMask) <<  6 | (b[2] & mbMask)
    } else {
        var b4Mask = 0x07 // first byte of a 4-byte encoding starts 11110 and carries 3 bits of data
        return (b0 & b4Mask) << 18 | (b[1] & mbMask) << 12 | (b[2] & mbMask) << 6 | (b[3] & mbMask)
    }
}

var tests = [
    ["LATIN CAPITAL LETTER A", 0x41],
    ["LATIN SMALL LETTER O WITH DIAERESIS", 0xf6],
    ["CYRILLIC CAPITAL LETTER ZHE", 0x416],
    ["EURO SIGN", 0x20ac],
    ["MUSICAL SYMBOL G CLEF", 0x1d11e]
]

System.print("Character   Name                                  Unicode    UTF-8 encoding (hex)")
System.print("---------------------------------------------------------------------------------")

for (test in tests) {
    var cp = test[1]
    var bytes = utf8_encode.call(cp)
    var utf8 = bytes.map { |b| Fmt.Xz(2, b) }.join(" ")
    var cp2 = utf8_decode.call(bytes)
    var uni = String.fromCodePoint(cp2)
    System.print("%(Fmt.s(-11, uni)) %(Fmt.s(-37, test[0])) U+%(Fmt.s(-8, Fmt.Xz(4, cp2))) %(utf8)")
}
