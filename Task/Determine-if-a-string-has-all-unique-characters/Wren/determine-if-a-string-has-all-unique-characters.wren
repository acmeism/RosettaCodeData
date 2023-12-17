import "./fmt" for Conv, Fmt

var analyze = Fn.new { |s|
    var chars = s.codePoints.toList
    var le = chars.count
    System.print("Analyzing %(Fmt.q(s)) which has a length of %(le):")
    if (le > 1) {
        for (i in 0...le-1) {
            for (j in i+1...le) {
                if (chars[j] == chars[i]) {
                    System.print("  Not all characters in the string are unique.")
                    var c = String.fromCodePoint(chars[i])
                    var hex = "0x" + Conv.hex(chars[i])
                    System.print("  '%(c)' (%(hex)) is duplicated at positions %(i+1) and %(j+1).\n")
                    return
                }
            }
        }
    }
    System.print("  All characters in the string are unique.\n")
}

var strings = [
    "",
    ".",
    "abcABC",
    "XYZ ZYX",
    "1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ",
    "01234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ0X",
    "hétérogénéité",
    "🎆🎃🎇🎈",
    "😍😀🙌💃😍🙌",
    "🐠🐟🐡🦈🐬🐳🐋🐡"
]
for (s in strings) analyze.call(s)
