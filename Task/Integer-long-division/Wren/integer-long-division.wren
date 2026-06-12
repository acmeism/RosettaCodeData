import "./big" for BigInt

var divide = Fn.new { |m, n|
    if (m < 0) Fiber.abort("m must not be negative")
    if (n <= 0) Fiber.abort("n must be positive.")
    var quotient = (m/n).toString + "."
    var c = (m % n) * 10
    var zeros = 0
    while (c > 0 && c < n) {
        c = c * 10
        quotient = quotient + "0"
        zeros = zeros + 1
    }
    var digits = ""
    var passed = {}
    var i = 0
    while (true) {
        var cs = c.toString
        if (passed.containsKey(cs)) {
            var prefix = digits[0...passed[cs]]
            var repetend = digits[passed[cs]..-1]
            var result = quotient + prefix + "(" + repetend + ")"
            result = result.replace("(0)", "").trimEnd(".")
            var index = result.indexOf("(")
            if (index == -1) return [result, "", 0]
            result = result.replace("(", "").replace(")", "")
            for (i in 0...zeros) {
                if (repetend[-1] == "0") {
                    result = result[0..-2]
                    repetend = "0" + repetend[0..-2]
                } else break
            }
            return [result + "....", repetend, repetend.count]
        }
        var q = c / n
        var r = c % n
        passed[cs] = i
        digits = digits + q.toString
        i = i + 1
        c = r * 10
    }
}

var tests = [
    [0, 1], [1, 1], [1, 3], [1, 7], [83,60], [1, 17], [10, 13], [3227, 555],
    [476837158203125, "9223372036854775808"], [1, 149], [1, 5261]
]
for (test in tests) {
    var a = BigInt.new(test[0])
    var b = BigInt.new(test[1])
    var res = divide.call(a, b)
    System.print("%(a)/%(b) = %(res[0])")
    System.print("Repetend is '%(res[1])'")
    System.print("Period is %(res[2])\n")
}
