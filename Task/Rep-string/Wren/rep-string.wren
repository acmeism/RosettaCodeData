import "./fmt" for Fmt

var repString = Fn.new { |s|
    var reps = []
    if (s.count < 2) return reps
    for (c in s) if (c != "0" && c != "1") Fiber.abort("Argument is not a binary string.")
    var size = s.count
    for (len in 1..(size/2).floor) {
        var t = s[0...len]
        var n = (size/len).floor
        var r = size % len
        var u = t * n + t[0...r]
        if (u == s) reps.add(t)
    }
    return reps
}

var strings = [
    "1001110011",
    "1110111011",
    "0010010010",
    "1010101010",
    "1111111111",
    "0100101101",
    "0100100",
    "101",
    "11",
    "00",
    "1"
]
System.print("The (longest) rep-strings are:\n")
for (s in strings) {
    var reps = repString.call(s)
    var t = (reps.count > 0) ? reps[-1] : "Not a rep-string"
    Fmt.print("$10s -> $s", s, t)
}
