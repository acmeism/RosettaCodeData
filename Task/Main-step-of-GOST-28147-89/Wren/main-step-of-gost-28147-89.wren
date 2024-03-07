import "./fmt" for Fmt

class GOST {
    // assumes 's' is an 8 x 16 integer array
    construct new(s) {
        _k87 = List.filled(256, 0)
        _k65 = List.filled(256, 0)
        _k43 = List.filled(256, 0)
        _k21 = List.filled(256, 0)
        _enc = List.filled(8, 0)
        for (i in 0..255) {
            _k87[i] = s[7][i>>4]<<4 | s[6][i&15]
            _k65[i] = s[5][i>>4]<<4 | s[4][i&15]
            _k43[i] = s[3][i>>4]<<4 | s[2][i&15]
            _k21[i] = s[1][i>>4]<<4 | s[0][i&15]
        }
    }

    enc { _enc }

    f(x) {
        x = _k87[x>>24&255]<<24 | _k65[x>>16&255]<<16 | _k43[x>>8&255]<<8 | _k21[x&255]
        return x<<11 | x>>(32-11)
    }

    mainStep(input, key) {
        var key32 = GOST.u32(key)
        var input1 = GOST.u32(input[0...4])
        var input2 = GOST.u32(input[4..-1])
        GOST.b4(f(key32+input1)^input2, enc)
        for (i in 0..3) enc[i + 4] = input[i]
    }

    static u32(b) { b[0] | b[1]<<8 | b[2]<<16 | b[3]<<24 }

    static b4(u, b) {
        b[0] = u & 0xff
        b[1] = (u >> 8) & 0xff
        b[2] = (u >> 16) & 0xff
        b[3] = (u >> 24) & 0xff
    }
}

var cbrf = [
    [ 4, 10,  9,  2, 13,  8,  0, 14,  6, 11,  1, 12,  7, 15,  5,  3],
    [14, 11,  4, 12,  6, 13, 15, 10,  2,  3,  8,  1,  0,  7,  5,  9],
    [ 5,  8,  1, 13, 10,  3,  4,  2, 14, 15, 12,  7,  6,  0,  9, 11],
    [ 7, 13, 10,  1,  0,  8,  9, 15, 14,  4,  6, 12, 11,  2,  5,  3],
    [ 6, 12,  7,  1,  5, 15, 13,  8,  4, 10,  9, 14,  0,  3, 11,  2],
    [ 4, 11, 10,  0,  7,  2,  1, 13,  3,  6,  8,  5,  9, 12, 15, 14],
    [13, 11,  4,  1,  3, 15,  5,  9,  0, 10, 14,  7,  6,  8,  2, 12],
    [ 1, 15, 13,  0,  5,  7, 10,  4,  9,  2,  3, 14,  6, 11,  8, 12]
]

var input = [0x21, 0x04, 0x3b, 0x04, 0x30, 0x04, 0x32, 0x04]
var key = [0xf9, 0x04, 0xc1, 0xe2]
var g = GOST.new(cbrf)
g.mainStep(input, key)
for (b in g.enc) Fmt.write("[$02x]", b)
System.print()
