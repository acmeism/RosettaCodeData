import "./dynamic" for Tuple
import "./big" for BigInt

var Solution = Tuple.create("Solution", ["root1", "root2", "exists"])

var ts = Fn.new { |n, p|
    if (n is Num) n = BigInt.new(n)
    if (p is Num) p = BigInt.new(p)

    var powModP = Fn.new { |a, e| a.modPow(e, p) }

    var ls = Fn.new { |a| powModP.call(a, p.dec / BigInt.two) }

    if (ls.call(n) != BigInt.one) return Solution.new(BigInt.zero, BigInt.zero, false)
    var q = p.dec
    var ss = BigInt.zero
    while (q & BigInt.one == BigInt.zero) {
        ss = ss.inc
        q = q >> 1
    }
    if (ss == BigInt.one) {
        var r1 = powModP.call(n, p.inc / BigInt.four)
        return Solution.new(r1, p - r1, true)
    }
    var z = BigInt.two
    while (ls.call(z) != p.dec) z = z.inc
    var c = powModP.call(z, q)
    var r = powModP.call(n, q.inc/BigInt.two)
    var t = powModP.call(n, q)
    var m = ss
    while (true) {
        if (t == BigInt.one) return Solution.new(r, p - r, true)
        var i = BigInt.zero
        var zz = t
        while (zz != BigInt.one && i < m.dec) {
            zz = zz * zz % p
            i = i.inc
        }
        var b = c
        var e = m - i.inc
        while (e > BigInt.zero) {
            b = b * b % p
            e = e.dec
        }
        r = r * b % p
        c = b * b % p
        t = t * c % p
        m = i
    }
}

var pairs = [
    [10, 13], [56, 101], [1030, 10009], [1032, 10009], [44402, 100049],
    [665820697, 1000000009], [881398088036, 1000000000039]
]

for (pair in pairs) {
    var n = pair[0]
    var p = pair[1]
    var sol = ts.call(n, p)
    System.print("n     = %(n)")
    System.print("p     = %(p)")
    if (sol.exists) {
        System.print("root1 = %(sol.root1)")
        System.print("root2 = %(sol.root2)")
    } else {
        System.print("No solution exists")
    }
    System.print()
}

var bn = BigInt.new("41660815127637347468140745042827704103445750172002")
var bp = BigInt.ten.pow(50) + BigInt.new(577)
var bsol = ts.call(bn, bp)
System.print("n     = %(bn)")
System.print("p     = %(bp)")
if (bsol.exists) {
    System.print("root1 = %(bsol.root1)")
    System.print("root2 = %(bsol.root2)")
} else {
    System.print("No solution exists")
}
