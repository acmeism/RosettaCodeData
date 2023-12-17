import "./sort" for Sort

var stx = "\x02"
var etx = "\x03"

var bwt = Fn.new { |s|
    if (s.indexOf(stx) >= 0 || s.indexOf(etx) >= 0) return null
    s = stx + s + etx
    var len = s.count
    var table = [""] * len
    table[0] = s
    for (i in 1...len) table[i] = s[i..-1] + s[0...i]
    Sort.quick(table)
    var lastChars = [""] * len
    for (i in 0...len) lastChars[i] = table[i][len-1]
    return lastChars.join()
}

var ibwt = Fn.new { |r|
    var len = r.count
    var table = [""] * len
    for (i in 0...len) {
        for (j in 0...len) table[j] = r[j] + table[j]
        Sort.quick(table)
    }
    for (row in table) {
        if (row.endsWith(etx)) return row[1...len-1]
    }
    return ""
}

var makePrintable = Fn.new { |s|
    // substitute ^ for STX and | for ETX to print results
    s = s.replace(stx, "^")
    return s.replace(etx, "|")
}

var tests = [
    "banana",
    "appellee",
    "dogwood",
    "TO BE OR NOT TO BE OR WANT TO BE OR NOT?",
    "SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES",
    "\x02ABC\x03"
]
for (test in tests) {
    System.print(makePrintable.call(test))
    System.write(" --> ")
    var t = bwt.call(test)
    if (t == null) {
        System.print("ERROR: String can't contain STX or ETX")
        t = ""
    } else {
        System.print(makePrintable.call(t))
    }
    var r = ibwt.call(t)
    System.print(" --> %(r)\n")
}
