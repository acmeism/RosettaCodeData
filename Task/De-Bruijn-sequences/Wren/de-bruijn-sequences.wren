import "/fmt" for Fmt
import "/str" for Str

var deBruijn = ""
for (n in 0..99) {
    var a = Fmt.rjust(2, n, "0")
    var a1 = a[0].bytes[0]
    var a2 = a[1].bytes[0]
    if (a2 >= a1) {
        deBruijn = deBruijn + ((a1 == a2) ? String.fromByte(a1): a)
        var m = n + 1
        while (m <= 99) {
            var ms = Fmt.rjust(2, m, "0")
            if (ms[1].bytes[0] > a1) deBruijn = deBruijn + a + ms
            m = m + 1
        }
    }
}

deBruijn = deBruijn + "000"
System.print("de Bruijn sequence length: %(deBruijn.count)\n")
System.print("First 130 characters:\n%(deBruijn[0...130])\n")
System.print("Last 130 characters:\n%(deBruijn[-130..-1])\n")

var check = Fn.new { |text|
    var res = []
    var found = List.filled(10000, 0)
    var k = 0
    for (i in 0...(text.count-3)) {
        var s = text[i..i+3]
        if (Str.allDigits(s)) {
            k = Num.fromString(s)
            found[k] = found[k] + 1
        }
    }
    for (i in 0...10000) {
        k = found[i]
        if (k != 1) {
            var e = "  Pin number %(Fmt.dz(4, i)) "
            e = e + ((k == 0) ? "missing" : "occurs %(k) times")
            res.add(e)
        }
    }
    k = res.count
    if (k == 0) {
        res = "No errors found"
    } else {
        var s = (k == 1) ? "" : "s"
        res = "%(k) error%(s) found:\n" + res.join("\n")
    }
    return res
}

System.print("Missing 4 digit PINs in this sequence: %(check.call(deBruijn))")
System.print("Missing 4 digit PINs in the reversed sequence: %(check.call(deBruijn[-1..0]))")

System.print("\n4,444th digit in the sequence: '%(deBruijn[4443])' (setting it to '.')")
deBruijn = deBruijn[0..4442] + "." + deBruijn[4444..-1]
System.print("Re-running checks: %(check.call(deBruijn))")
