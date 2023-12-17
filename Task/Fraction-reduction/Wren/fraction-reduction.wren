import "./dynamic" for Struct
import "./fmt" for Fmt

var Result = Struct.create("Result", ["n", "nine"])

var toNumber = Fn.new { |digits, removeDigit|
    var digits2 = digits.toList
    if (removeDigit != 0) {
        var d = digits2.indexOf(removeDigit)
        digits2.removeAt(d)
    }
    var res = digits2[0]
    var i = 1
    while (i < digits2.count) {
        res = res * 10 + digits2[i]
        i = i + 1
    }
    return res
}

var nDigits = Fn.new { |n|
    var res = []
    var digits = List.filled(n, 0)
    var used = List.filled(9, false)
    for (i in 0...n) {
        digits[i] = i + 1
        used[i] = true
    }
    while (true) {
        var nine = List.filled(9, 0)
        for (i in 0...used.count) {
            if (used[i]) nine[i] = toNumber.call(digits, i+1)
        }
        res.add(Result.new(toNumber.call(digits, 0), nine))
        var found = false
        for (i in n-1..0) {
            var d = digits[i]
            if (!used[d-1]) {
                Fiber.abort("something went wrong with 'used' array")
            }
            used[d-1] = false
            var j = d
            while (j < 9) {
                if (!used[j]) {
                    used[j] = true
                    digits[i] = j + 1
                    for (k in i + 1...n) {
                        digits[k] = used.indexOf(false) + 1
                        used[digits[k]-1] = true
                    }
                    found = true
                    break
                }
                j = j + 1
            }
            if (found) break
        }
        if (!found) break
    }
    return res
}

for (n in 2..5) {
    var rs = nDigits.call(n)
    var count = 0
    var omitted = List.filled(9, 0)
    for (i in 0...rs.count-1) {
        var xn = rs[i].n
        var rn = rs[i].nine
        for (j in i + 1...rs.count) {
            var xd = rs[j].n
            var rd = rs[j].nine
            for (k in 0..8) {
                var yn = rn[k]
                var yd = rd[k]
                if (yn != 0 && yd != 0 && xn/xd == yn/yd) {
                    count = count + 1
                    omitted[k] = omitted[k] + 1
                    if (count <= 12) {
                        Fmt.print("$d/$d => $d/$d (removed $d)", xn, xd, yn, yd, k+1)
                    }
                }
            }
        }
    }
    Fmt.print("$d-digit fractions found:$d, omitted $s\n", n, count, omitted)
}
