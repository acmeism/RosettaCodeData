var isCusip = Fn.new { |s|
    if (s.count != 9) return false
    var sum = 0
    for (i in 0..7) {
        var c = s[i].bytes[0]
        var v
        if (c >= 48 && c <= 57) { // '0' to '9'
            v = c - 48
        } else if (c >= 65 && c <= 90) { // 'A' to 'Z'
            v = c - 55
        } else if (s[i] == "*") {
            v = 36
        } else if (s[i] == "@") {
            v = 37
        } else if (s[i] == "#") {
            v = 38
        } else {
            return false
        }
        if (i%2 == 1) v = v * 2 // check if odd as using 0-based indexing
        sum = sum + (v/10).floor + v%10
    }
    return s[8].bytes[0] - 48 == (10 - (sum%10)) % 10
}

var candidates = [
    "037833100",
    "17275R102",
    "38259P508",
    "594918104",
    "68389X106",
    "68389X105"
]
for (candidate in candidates) {
    var b = (isCusip.call(candidate)) ? "correct" : "incorrect"
    System.print("%(candidate) -> %(b)")
}
