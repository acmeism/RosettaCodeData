import "./big" for BigInt
import "./dynamic" for Tuple

var Point = Tuple.create("Point", ["x", "y"])
var bigBig = BigInt.ten.pow(50) + BigInt.new(151)

var c = Fn.new { |ns, ps|
    var n = BigInt.new(ns)
    var p = (ps != "") ? BigInt.new(ps) : bigBig

    // Legendre symbol, returns 1, 0 or p - 1
    var ls = Fn.new { |a| a.modPow((p - BigInt.one) / BigInt.two, p) }

    // Step 0, validate arguments
    if (ls.call(n) != BigInt.one) return [BigInt.zero, BigInt.zero, false]

    // Step 1, find a, omega2
    var a = BigInt.zero
    var omega2
    while (true) {
        omega2 = (a * a + p - n) % p
        if (ls.call(omega2) == p - BigInt.one) break
        a = a.inc
    }

    // multiplication in Fp2
    var mul = Fn.new { |aa, bb|
        return Point.new((aa.x * bb.x + aa.y * bb.y * omega2) % p,
                         (aa.x * bb.y + bb.x * aa.y) % p)
    }

    // Step 2, compute power
    var r = Point.new(BigInt.one, BigInt.zero)
    var s = Point.new(a, BigInt.one)
    var nn = ((p + BigInt.one) >> 1) % p
    while (nn > BigInt.zero) {
        if ((nn & BigInt.one) == BigInt.one) r = mul.call(r, s)
        s = mul.call(s, s)
        nn = nn >> 1
    }

    // Step 3, check x in Fp
    if (r.y != BigInt.zero) return [BigInt.zero, BigInt.zero, false]

    // Step 5, check x * x = n
    if (r.x * r.x % p != n) return [BigInt.zero, BigInt.zero, false]

    // Step 4, solutions
    return [r.x, p - r.x, true]
}

System.print(c.call("10", "13"))
System.print(c.call("56", "101"))
System.print(c.call("8218", "10007"))
System.print(c.call("8219", "10007"))
System.print(c.call("331575", "1000003"))
System.print(c.call("665165880", "1000000007"))
System.print(c.call("881398088036", "1000000000039"))
System.print(c.call("34035243914635549601583369544560650254325084643201", ""))
