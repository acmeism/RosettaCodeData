import "./gmp" for Mpf
import "./math" for Int
import "./fmt" for Fmt

var isSquareFree = Fn.new { |n|
    var i = 2
    while (i * i <= n) {
        if (n%(i*i) == 0) return false
        i = (i > 2) ? i + 2 : i + 1
    }
    return true
}

var mu = Fn.new { |n|
    if (n < 1) Fiber.abort("Argument must be a positive integer")
    if (n == 1) return 1
    var sqFree = isSquareFree.call(n)
    var factors = Int.primeFactors(n)
    if (sqFree && factors.count % 2 == 0) return 1
    if (sqFree) return -1
    return 0
}

var meisselMertens = Fn.new { |d|
    Mpf.defaultPrec = d
    var z = Mpf.zero
    var y = Mpf.zero
    var r = Mpf.new()
    var q = Mpf.new()
    var t = Mpf.new()
    var m = Mpf.new()
    for (p in [2, 3, 5, 7]) {
        r.setUi(p).inv
        t.uiSub(1, r).log.add(r)
        z.add(t, z)
    }
    for (k in 2..d) {
        q.setUi(1)
        for (p in [2, 3, 5, 7]) {
            r.setUi(p).inv
            t.uiSub(1, r.pow(k))
            q.mul(t)
        }
        m.setSi(mu.call(k))
        t.zetaUi(k).mul(q).log.mul(m).div(k)
        y.add(t, y)
    }
    return Mpf.euler.add(z).add(y)
}

Fmt.print("$20a", meisselMertens.call(3300).toString(1001))
