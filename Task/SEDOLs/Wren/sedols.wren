import "./str" for Char
import "./fmt" for Conv

var sedol = Fn.new { |s|
    if (!(s is String && s.count == 6)) return false
    var weights = [1, 3, 1, 7, 3, 9]
    var sum = 0
    for (i in 0..5) {
        var c = s[i]
        if (!Char.isUpper(c) && !Char.isDigit(c)) return null
        if ("AEIOU".contains(c)) return null
        sum = sum + Conv.atoi(c, 36) * weights[i]
    }
    var cd = (10 - sum%10) % 10
    return s + "%(cd)"
}

var tests = [
    "710889",
    "B0YBKJ",
    "406566",
    "B0YBLH",
    "228276",
    "B0YBKL",
    "557910",
    "B0YBKR",
    "585284",
    "B0YBKT",
    "B00030",
    "I23456"
]

for (test in tests) {
    var a
    var ans = (a = sedol.call(test)) ? a : "not valid"
    System.print("%(test) -> %(ans)")
}
