import "./fmt" for Conv, Fmt

var analyze = Fn.new { |s|
    var chars = s.codePoints.toList
    var le = chars.count
    System.print("Analyzing %(Fmt.q(s)) which has a length of %(le):")
    if (le > 1) {
        for (i in 1...le) {
            if (chars[i] != chars[i-1]) {
                System.print("  Not all characters in the string are the same.")
                var c = String.fromCodePoint(chars[i])
                var hex = Conv.hex(chars[i])
                System.print("  '%(c)' (0x%(hex)) is different at position %(i+1).\n")
                return
            }
        }
    }
    System.print("  All characters in the string are the same.\n")
}

var strings = [
    "",
    "   ",
    "2",
    "333",
    ".55",
    "tttTTT",
    "4444 444k",
    "pépé",
    "🐶🐶🐺🐶",
    "🎄🎄🎄🎄"
]
for (s in strings) analyze.call(s)
