import "./big" for BigRat
import "./fmt" for Fmt

var pi = "3.1415926535897932384626433832795028841971693993751058209749445923078164"
var bigPi = BigRat.fromDecimal(pi)

var exp = Fn.new { |x, p|
    var sum = x + 1
    var prevTerm = x
    var k = 2
    var eps = BigRat.fromDecimal("0.5e-%(p)")
    while (true) {
        var nextTerm = prevTerm * x / k
        sum = sum + nextTerm
        if (nextTerm < eps) break
        // speed up calculations by limiting precision to 'p' places
        prevTerm = BigRat.fromDecimal(nextTerm.toDecimal(p))
        k = k + 1
    }
    return sum
}

var ramanujan = Fn.new { |n, dp|
    var e = bigPi * BigRat.new(n, 1).sqrt(70)
    return exp.call(e, 70)
}

System.print("Ramanujan's constant to 32 decimal places is:")
System.print(ramanujan.call(163, 32).toDecimal(32))
var heegner = [19, 43, 67, 163]
System.print("\nHeegner numbers yielding almost integers:")
for (h in heegner) {
    var r = ramanujan.call(h, 32)
    var rc = r.ceil
    var diff = (rc - r).toDecimal(32)
    r = r.toDecimal(32)
    rc = rc.toDecimal(32)
    Fmt.print("$3d: $51s ≈ $18s (diff: $s)", h, r, rc, diff)
}
