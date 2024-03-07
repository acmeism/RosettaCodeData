/* Man_or_boy_test_2.wren */

import "./gmp" for Mpz
import "./fmt" for Fmt

var A = Fn.new { |k|
    if (k < 6) {
        var x1 = 1
        var x2 = -1
        var x3 = -1
        var x4 = 1
        var c1 = [0, 0, 0, 1, 2, 3][k]
        var c2 = [0, 0, 1, 1, 1, 2][k]
        var c3 = [0, 1, 1, 0, 0, 1][k]
        var c4 = [1, 1, 0, 0, 0, 0][k]
        return c1*x1 + c2*x2 + c3*x3 + c4*x4
    }
    var one = Mpz.one
    var c0  = Mpz.three
    var c1  = Mpz.two
    var c2  = Mpz.one
    var c3  = Mpz.zero
    for (j in 5...k) {
        c3.add(c0).sub(one)
        c0.add(c1)
        c1.add(c2)
        c2.add(c3)
    }
    return c0.add(c0.sub(c0.sub(c1), c2), c3)
}

var p = Fn.new { |k|
    Fmt.write("A($d) = ", k)
    var s = A.call(k).toString
    if (s.count < 60) {
        System.print(s)
    } else {
        Fmt.print("$s...$s ($d digits)", s[0..5], s[-5..-1], s.count - 1)
    }
}

for (i in 0..39) p.call(i)
p.call(500)
p.call(10000)
p.call(1e6)
