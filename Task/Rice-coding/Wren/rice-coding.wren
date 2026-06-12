import "./math" for Int, Math
import "./check" for Check
import "./fmt" for Fmt

class Rice {
    static encode(n, k) {
        Check.nonNegInt("n", n)
        var m = 1 << k
        var q = Int.quo(n, m)
        var r = n % m
        var res = List.filled(q, 1)
        res.add(0)
        var digits = Int.digits(r, 2)
        var dc = digits.count
        if (dc < k) res.addAll([0] * (k - dc))
        res.addAll(digits)
        return res
    }

    static encodeEx(n, k) { encode(n < 0 ? -2 * n - 1 : 2 * n, k) }

    static decode(a, k) {
        var m = 1 << k
        var q = a.indexOf(0)
        if (q == -1) q = 0
        var r = Math.evalPoly(a[q..-1], 2)
        return q * m + r
    }

    static decodeEx(a, k) {
        var i = decode(a, k)
        return i % 2 == 1 ? -Int.quo(i+1, 2) : Int.quo(i, 2)
    }
}

System.print("Basic Rice coding (k = 2):")
for (i in 0..10) {
    var res = Rice.encode(i, 2)
    Fmt.print("$2d -> $-6s -> $d", i, res.join(""), Rice.decode(res, 2))
}

System.print("\nExtended Rice coding (k == 2):")
for (i in -10..10) {
    var res = Rice.encodeEx(i, 2)
    Fmt.print("$3d -> $-9s -> $ d", i, res.join(""), Rice.decodeEx(res, 2))
}

System.print("\nBasic Rice coding (k == 4):")
for (i in 0..17) {
    var res = Rice.encode(i, 4)
    Fmt.print("$2d -> $-6s -> $d", i, res.join(""), Rice.decode(res, 4))
}
