import "/fmt" for Fmt

var digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

var encodeNegBase = Fn.new { |n, b|
    if (b < -62 || b > -1) Fiber.abort("Base must be between -1 and -62")
    if (n == 0) return "0"
    var out = ""
    while (n != 0) {
        var rem = n % b
        n = (n/b).truncate
        if (rem < 0) {
            n = n + 1
            rem = rem -b
        }
        out = out + digits[rem]
    }
    return out[-1..0]
}

var decodeNegBase = Fn.new { |ns, b|
    if (b < -62 || b > -1) Fiber.abort("Base must be between -1 and -62")
    if (ns == "0") return 0
    var total = 0
    var bb = 1
    for (c in ns[-1..0]) {
        total = total + digits.indexOf(c)*bb
        bb = bb * b
    }
    return total
}

var nbl = [ [10, -2], [146, -3], [15, -10], [-7425195, -62] ]
for (p in nbl) {
    var ns = encodeNegBase.call(p[0], p[1])
    Fmt.print("$8d encoded in base $-3d = $s", p[0], p[1], ns)
    var n = decodeNegBase.call(ns, p[1])
    Fmt.print("$8s decoded in base $-3d = $d\n", ns, p[1], n)
}
