var isbn13 = Fn.new { |s|
    var cps = s.codePoints
    var digits = []
    // extract digits
    for (i in 0...cps.count) {
        var c = cps[i]
        if (c >= 48 && c <= 57) digits.add(c)
    }
    // do calcs
    var sum = 0
    for (i in 0...digits.count) {
        var d = digits[i] - 48
        sum = sum + ((i%2 == 0) ? d : 3 * d)
    }
    return sum % 10 == 0
}

var tests = ["978-1734314502", "978-1734314509", "978-1788399081", "978-1788399083"]
for (test in tests) {
    System.print("%(test) -> %(isbn13.call(test) ? "good" : "bad")")
}
