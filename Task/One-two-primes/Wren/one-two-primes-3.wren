import "./gmp" for Mpz
import "./fmt" for Fmt
import "./iterate" for Stepped

var firstPrime = Fn.new { |n, d|
    var k = Mpz.ten.pow(n).sub(Mpz.one).div(Mpz.nine)
    var r = Mpz.one.lsh(n).sub(Mpz.one)
    var m = Mpz.zero
    while (m <= r) {
        var t = k + Mpz.fromStr(m.toString(2))
        var s = t.toString
        if (d[0] != 2) {
            if (d[0] != 1) s = s.replace("1", d[0].toString)
            if (d[1] != 2) s = s.replace("2", d[1].toString)
        } else {
            s = s.replace("1", "x").replace("2", d[1].toString).replace("x", "2")
        }
        if (s[0] == "0") s = "1" + s[1..-1]
        t.setStr(s)
        if (t.probPrime(15) > 0) return t
        m.inc
    }
    return Mpz.zero
}

var digits = [
    [0, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7], [1, 8],
    [1, 9], [2, 3], [2, 7], [2, 9], [3, 4], [3, 5], [3, 7], [3, 8],
    [4, 7], [4, 9], [5, 7], [5, 9], [6, 7], [7, 8], [7, 9], [8, 9]
]
for (d in digits) {
    Fmt.print("Smallest n digit prime using only $d and $d (or '0' if none exists)", d[0], d[1])
    for (n in 1..20) Fmt.print("$3d: $i", n, firstPrime.call(n, d))
    for (n in Stepped.new(100..200, 100)) {
        var t = firstPrime.call(n, d)
        var ts = t.toString
        if (d[0] != 0) {
            var ix = ts.indexOf(d[1].toString)
            Fmt.print("$3d: ($d x $3d) $s", n, d[0], ix, ts[ix..-1])
        } else {
            var ix = ts[1..-1].indexOf(d[1].toString)
            Fmt.print("$3d: $d (0 x $3d) $s", n, d[1], ix, ts[ix..-1])
        }
    }
    System.print()
}
