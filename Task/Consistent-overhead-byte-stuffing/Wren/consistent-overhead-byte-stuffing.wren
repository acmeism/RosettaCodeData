import "./fmt" for Fmt

class COBS {
    static isByte(i) { (i is Num) && i.isInteger && i >= 0 && i < 256 }

    static encode(data, delim) {
        if (!((data is List) && data.count > 0 && data.all { |i| isByte(i) })) {
            Fiber.abort("data must be a non-empty list of bytes.")
        }
        var enc = [-1]
        var ins = 0
        var code = 1
        var addLastCode = true
        for (byte in data) {
            if (byte != 0) {
                enc.add(byte)
                code = code + 1
            }
            addLastCode = true
            if (byte == 0|| code == 255) {
                if (code == 255) addLastCode = false
                enc[ins] = code
                code = 1
                ins = enc.count
                enc.add(-1)
            }
        }
        if (addLastCode) {
            enc[ins] = code
            if (delim != 0) for (i in 0...enc.count) enc[i] = enc[i] ^ delim
            enc.add(delim)
        } else {
            if (delim != 0) for (i in 0...enc.count) enc[i] = enc[i] ^ delim
            enc[ins] = delim
        }
        return enc
    }

    static decode(enc, delim) {
        if (!((enc is List) && enc.count > 0 && enc[-1] == delim &&
            enc.all { |i| isByte(i) })) {
            Fiber.abort("encoded data must be a non-empty list of delimiter-terminated bytes.")
        }
        var enc2 = enc[0..-2]
        var length = enc2.count
        if (delim != 0) for (i in 0...length) enc2[i] = enc[i] ^ delim
        var dec = []
        var code = 255
        var block = 0
        for (i in 0...length) {
            var byte = enc2[i]
            if (block != 0) {
                dec.add(byte)
            } else {
                if (i + byte > length) Fiber.abort("marker pointing beyond the end of the packet.")
                if (code != 255) dec.add(0)
                code = byte
                block = code
                if (code == 0) break
            }
            block = block - 1
        }
        return dec
    }
}

var examples = [
    [0x00],
    [0x00, 0x00],
    [0x00, 0x11, 0x00],
    [0x11, 0x22, 0x00, 0x33],
    [0x11, 0x22, 0x33, 0x44],
    [0x11, 0x00, 0x00, 0x00],
    (0x01..0xfe).toList,
    (0x00..0xfe).toList,
    (0x01..0xff).toList,
    (0x02..0xff).toList + [0x00],
    (0x03..0xff).toList + [0x00, 0x01]
]

for (delim in [0x00, 0x02]) {
    var encoded = []
    Fmt.print("COBS encoding (hex) with delimiter $#02x:", delim)
    for (example in examples) {
        var res = COBS.encode(example, delim)
        encoded.add(res)
        if (example.count < 5) {
            Fmt.print("$-33s -> $02X", Fmt.swrite("$02X", example), res)
        } else {
            var e = Fmt.va("Xz", 2, example, 0, " ", "", "", 5, "...")
            var r = Fmt.va("Xz", 2, res, 0, " ", "", "", 5, "...")
            Fmt.print("$s -> $s", e, r)
        }
    }
    Fmt.print("\nCOBS decoding (hex) with delimiter $#02x:", delim)
    for (enc in encoded) {
        var res = COBS.decode(enc, delim)
        if (enc.count < 7) {
            Fmt.print("$-33s -> $02X", Fmt.swrite("$02X", enc), res)
        } else {
            var e = Fmt.va("Xz", 2, enc, 0, " ", "", "", 5, "...")
            var r = Fmt.va("Xz", 2, res, 0, " ", "", "", 5, "...")
            Fmt.print("$s -> $s", e, r)
        }
    }
    System.print()
}
