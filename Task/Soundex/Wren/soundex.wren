import "/str" for Char
import "/fmt" for Fmt

var getCode = Fn.new { |c|
    return "BFPV".contains(c)     ? "1" :
           "CGJKQSXZ".contains(c) ? "2" :
            c == "D" || c == "T"  ? "3" :
            c == "L"              ? "4" :
            c == "M" || c == "N"  ? "5" :
            c == "R"              ? "6" :
            c == "H" || c == "W"  ? "-" : ""
}

var soundex = Fn.new { |s|
    if (s == "") return ""
    var sb = Char.upper(s[0])
    var prev = getCode.call(sb[0])
    for (c in s.skip(1)) {
        var curr = getCode.call(Char.upper(c))
        if (curr != "" && curr != "-" && curr != prev) sb = sb + curr
        if (curr != "-") prev = curr
    }
    return Fmt.ljust(4, sb, "0")[0..3]
}

var pairs = [
    ["Ashcraft",  "A261"],
    ["Ashcroft",  "A261"],
    ["Gauss",     "G200"],
    ["Ghosh",     "G200"],
    ["Hilbert",   "H416"],
    ["Heilbronn", "H416"],
    ["Lee",       "L000"],
    ["Lloyd",     "L300"],
    ["Moses",     "M220"],
    ["Pfister",   "P236"],
    ["Robert",    "R163"],
    ["Rupert",    "R163"],
    ["Rubin",     "R150"],
    ["Tymczak",   "T522"],
    ["Soundex",   "S532"],
    ["Example",   "E251"]
]

for (pair in pairs) {
    Fmt.print("$-9s -> $s -> $s", pair[0], pair[1], soundex.call(pair[0]) == pair[1])
}
