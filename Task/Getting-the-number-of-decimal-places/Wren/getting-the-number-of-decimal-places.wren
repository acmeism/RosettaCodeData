var error = "Argument must be a number or a decimal numeric string."

var getNumDecimals = Fn.new { |n|
    if (n is Num) {
        if (n.isInteger) return 0
        n = n.toString
    } else if (n is String) {
        if (n == "") Fiber.abort(error)
        if (n[0] == "+" || n[0] == "-") n = n[1..-1]
        if (!n.all { |c| "0123456789.".contains(c) }) Fiber.abort(error)
    } else {
        Fiber.abort(error)
    }
    var s = n.split(".")
    var c = s.count
    return (c == 1) ? 0 : (c == 2) ? s[1].count : Fiber.abort("Too many decimal points.")
}

var a = [12, 12.345, 12.345555555555, "12.3450", "12.34555555555555555555", 12.345e53]
for (n in a) {
    var d = getNumDecimals.call(n)
    var ns = (n is String) ? "\"%(n)\"" : "%(n)"
    System.print("%(ns) has %(d) decimals")
}
