import "./check" for Check
import "./math" for Int
import "./str" for Str
import "./fmt" for Fmt

class BCD {
    static init_() {
        __bcd = [
            "0000", "0001", "0010", "0011", "0100",
            "0101", "0110", "0111", "1000", "1001"
        ]
        __dec = {
            "0000": "0", "0001": "1", "0010": "2", "0011": "3", "0100": "4",
            "0101": "5", "0110": "6", "0111": "7", "1000": "8", "1001": "9"
        }
    }

    construct new(n) {
        if (n is String) {
            if (n.startsWith("0x")) n = n[2..-1]
            n = Num.fromString(n)
        }
        Check.nonNegInt("n", n)
        if (!__bcd) BCD.init_()
        _b = ""
        for (digit in Int.digits(n)) _b = _b + __bcd[digit]
    }

    toInt {
        var ns = ""
        for (nibble in Str.chunks(_b, 4)) ns = ns + __dec[nibble]
        return Num.fromString(ns)
    }

    +(other) {
        if (!(other is BCD)) other = BCD.new(other)
        return BCD.new(this.toInt + other.toInt)
    }

    -(other) {
        if (!(other is BCD)) other = BCD.new(other)
        return BCD.new(this.toInt - other.toInt)
    }

    toString {
        var ret = _b.trimStart("0")
        if (ret == "") ret = "0"
        return ret
    }

    toUnpacked {
        var ret = ""
        for (nibble in Str.chunks(_b, 4)) ret = ret + "0000" + nibble
        ret = ret.trimStart("0")
        if (ret == "") ret = "0"
        return ret
    }

    toHex { "0x" + this.toInt.toString }
}

var hexs = ["0x19", "0x30", "0x99"]
var ops  = ["+", "-", "+"]
for (packed in [true, false]) {
    for (i in 0...hexs.count) {
        var op = ops[i]
        var bcd = BCD.new(hexs[i])
        var bcd2 = (op == "+") ? bcd + 1 : bcd - 1
        var str = packed ? bcd.toString : bcd.toUnpacked
        var str2 = packed ? bcd2.toString : bcd2.toUnpacked
        var hex = bcd.toHex
        var hex2 = bcd2.toHex
        var un = packed ? "" : "un"
        var w = packed ? 8 : 12
        var args = [hex, op, hex2, un, w, str, op, str2]
        Fmt.lprint("$s $s 1 = $-5s or, in $0spacked BCD, $*s $s 1 = $s", args)
    }
    if (packed) System.print()
}
