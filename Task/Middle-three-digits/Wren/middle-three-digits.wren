import "/fmt" for Fmt

var middle3 = Fn.new { |n|
    if (n < 0) n = -n
    var s = "%(n)"
    var c = s.count
    if (c < 3) return "Minimum is 3 digits, only has %(c)."
    if (c%2 == 0) return "Number of digits must be odd, %(c) is even."
    if (c == 3) return s
    var d = (c - 3)/2
    return s[d..d+2]
}

var a = [123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345,
    1, 2, -1, -10, 2002, -2002, 0]

for (e in a) {
    System.print("%(Fmt.s(9, e)) -> %(middle3.call(e))")
}
