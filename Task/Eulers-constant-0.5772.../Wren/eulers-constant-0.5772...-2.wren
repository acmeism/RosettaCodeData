import "./gmp" for Mpf

var euler = Fn.new { |n, r, s, t|
    // decimal precision
    var e10 = (n/0.6).floor

    // binary precision
    var e2 = ((1 + n/0.6)/0.30103).round
    Mpf.defaultPrec = e2

    var b = Mpf.new().log(Mpf.from(16).div(15))
    var a = b.mul(r)
    b = Mpf.new().log(Mpf.from(25).div(24))
    a.add(b.mul(s))
    b = Mpf.new().log(Mpf.from(81).div(80))
    var u = b * t
    a.add(u).neg
    b.set(1)
    u.set(a)
    var v = Mpf.from(b)
    var k = 0
    var n2 = n * n
    var k2 = Mpf.zero
    while (true) {
        k2.add((k << 1) + 1)
        k = k + 1
        b.mul(n2).div(k2)
        a.mul(n2).div(k).add(b).div(k)
        u.add(a)
        v.add(b)
        var e = Mpf.frexp(a)[1]
        if (e.abs >= e2) break
    }
    u.div(v)
    System.print("gamma %(u.toString(10, 100)) (maxerr. 1e-%(e10))")
    System.print("k = %(k)")
}

var start = System.clock
euler.call(60, 41, 30, 18)
euler.call(4800, 85, 62, 37)
euler.call(9375, 91, 68, 40)
euler.call(18750, 98, 73, 43)
System.print("\nTook %(System.clock - start) seconds.")
