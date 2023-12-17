import "./fmt" for Fmt

// Returns collapsed string, original and new lengths in
// unicode code points (not normalized).
var collapse = Fn.new { |s|
    var c = s.codePoints.toList
    var le = c.count
    if (le < 2) return [s, le, le]
    for (i in le-2..0) {
        if (c[i] == c[i+1]) c.removeAt(i)
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

for (s in strings) {
    var r = collapse.call(s)
    System.print("original : length = %(Fmt.d(2, r[1])), string = «««%(s)»»»")
    System.print("collapsed: length = %(Fmt.d(2, r[2])), string = «««%(r[0])»»»\n")
}
