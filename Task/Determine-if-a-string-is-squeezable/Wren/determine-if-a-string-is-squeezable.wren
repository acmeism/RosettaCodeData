import "/fmt" for Fmt

// Returns squeezed string, original and new lengths in
// unicode code points (not normalized).
var squeeze = Fn.new { |s, ch|
    var c = s.codePoints.toList
    var le = c.count
    if (le < 2) return [s, le, le]
    for (i in le-2..0) {
        if (c[i] == ch.codePoints[0] && c[i] == c[i+1]) c.removeAt(i)
    }
    var cc = c.reduce("") { |acc, cp| acc + String.fromCodePoint(cp) }
    return [cc, le, cc.count]
}

var strings = [
    "",
    "\"If I were two-faced, would I be wearing this one?\" --- Abraham Lincoln ",
    "..1111111111111111111111111111111111111111111111111111111111111117777888",
    "I never give 'em hell, I just tell the truth, and they think it's hell. ",
    "                                                   ---  Harry S Truman  ",
    "The better the 4-wheel drive, the further you'll be from help when ya get stuck!",
    "headmistressship",
    "aardvark",
    "😍😀🙌💃😍😍😍🙌"
]

var chars = [ [" "], ["-"], ["7"], ["."], [" ", "-", "r"], ["e"], ["s"], ["a"], ["😍"] ]

var i = 0
for (s in strings) {
    for (ch in chars[i]) {
        var r = squeeze.call(s, ch)
        System.print("Specified character = '%(ch)'")
        System.print("original : length = %(Fmt.d(2, r[1])), string = «««%(s)»»»")
        System.print("squeezed : length = %(Fmt.d(2, r[2])), string = «««%(r[0])»»»\n")
    }
    i = i + 1
}
