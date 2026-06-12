import "./gmp" for Mpz
import "./fmt" for Fmt
import "./iterate" for Stepped

var firstOneTwo = Fn.new { |n|
    var k = Mpz.ten.pow(n).sub(Mpz.one).div(Mpz.nine)
    var r = Mpz.one.lsh(n).sub(Mpz.one)
    var m = Mpz.zero
    while (m <= r) {
        var t = k + Mpz.fromStr(m.toString(2))
        if (t.probPrime(15) > 0) return t
        m.inc
    }
    return Mpz.minusOne
}

for (n in 1..20) Fmt.print("$4d: $i", n, firstOneTwo.call(n))
for (n in Stepped.new(100..2000, 100)) {
    var t = firstOneTwo.call(n)
    if (t == Mpz.minusOne) {
        System.print("No %(n)-digit prime found with only digits 1 or 2.")
    } else {
        var ts = t.toString
        var ix = ts.indexOf("2")
        Fmt.print("$4d: (1 x $4d) $s", n, ix, ts[ix..-1])
    }
}
