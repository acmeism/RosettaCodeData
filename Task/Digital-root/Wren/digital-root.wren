import "./fmt" for Fmt

var sumDigits = Fn.new { |n|
    var sum = 0
    while (n > 0) {
        sum = sum + (n%10)
        n = (n/10).floor
    }
    return sum
}

var digitalRoot = Fn.new { |n|
    if (n < 0) Fiber.abort("Argument must be non-negative.")
    if (n < 10) return [n, 0]
    var dr = n
    var ap = 0
    while (dr > 9) {
        dr = sumDigits.call(dr)
        ap = ap + 1
    }
    return [dr, ap]
}

var a = [1, 14, 267, 8128, 627615, 39390, 588225, 393900588225]
for (n in a) {
    var res = digitalRoot.call(n)
    var dr = res[0]
    var ap = res[1]
    Fmt.print("$,15d has additive persistence $d and digital root of $d", n, ap, dr)
}
