import "/big" for BigInt
import "/fmt" for Fmt

var solvePell = Fn.new { |n|
    n = BigInt.new(n)
    var x = n.isqrt
    var y = x.copy()
    var z = BigInt.one
    var r = x * 2
    var e1 = BigInt.one
    var e2 = BigInt.zero
    var f1 = BigInt.zero
    var f2 = BigInt.one
    while (true) {
        y = r*z - y
        z = (n - y*y) / z
        r = (x + y) / z
        var t = e1.copy()
        e1 = e2.copy()
        e2 = r*e2 + t
        t = f1.copy()
        f1 = f2.copy()
        f2 = r*f2 + t
        var a = e2 + x*f2
        var b = f2.copy()
        if (a*a - n*b*b == BigInt.one) return [a, b]
    }
}

for (n in [61, 109, 181, 277]) {
    var res = solvePell.call(n)
    Fmt.print("x² - $3dy² = 1 for x = $-21i and y = $i", n, res[0], res[1])
}
