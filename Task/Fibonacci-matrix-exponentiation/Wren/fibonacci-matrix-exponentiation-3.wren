import "./gmp" for Mpz, Mpf
import "./fmt" for Fmt

var nd = 20   // number of digits to be displayed at each end
var pr = 128  // precision to be used

var one = Mpz.one
var two = Mpz.two

var fibmod = Fn.new { |n, nmod|
    if (n < two) return n
    var fibmods = {}
    var f // recursive closure
    f = Fn.new { |n|
        if (n < two) return one
        var ns = n.toString
        var v = fibmods[ns]
        if (v) return v
        v = Mpz.zero
        var k = n / two
        var t = n & one
        var u = Mpz.zero
        if (t != one) {
            t.set(f.call(k)).square
            v.sub(k, one)
            u.set(f.call(v)).square
        } else {
            t.set(f.call(k))
            v.add(k, one)
            v.set(f.call(v))
            u.sub(k, one)
            u.set(f.call(u)).mul(t)
            t.mul(v)
        }
        t.add(u)
        fibmods[ns] = t.rem(nmod)
        return fibmods[ns]
    }
    var w = n - one
    return f.call(w)
}

var binetApprox = Fn.new { |n|
    var phi = Mpf.from(0.5, pr)
    var ihp = phi.copy()
    var root = Mpf.from(1.25, pr).sqrt
    phi.add(root)
    ihp.sub(root, ihp).neg
    ihp.sub(phi, ihp).log
    phi.log
    var nn = Mpf.from(n, pr)
    return phi.mul(nn).sub(ihp)
}

var firstFibDigits = Fn.new { |n, k|
    var f = binetApprox.call(n)
    var g = Mpf.new(pr)
    g.div(f, Mpf.ln10(pr)).inc
    g.floor.mul(Mpf.ln10(pr))
    f.sub(g).exp
    var p = Mpz.from(10).pow(k)
    g.set(p)
    f.mul(g)
    return f.floor.toString[0...k]
}

var lastFibDigits = Fn.new { |n, k|
    var p = Mpz.from(10).pow(k)
    return fibmod.call(n, p).toString[0...k]
}

var start = System.clock
var n = Mpz.zero
var i = 10
while (i <= 1e7) {
    n.set(i)
    var nn = Mpz.from(i)
    Fmt.print("\nThe digits of the $,r Fibonacci number are:", i)
    var nd2 = nd
    var nd3 = nd
    // These need to be preset for i == 10 & i == 100
    // as there is no way of deriving the total length of the string using this method.
    if (i == 10) {
        nd2 = 2
    } else if (i == 100) {
        nd3 = 1
    }
    var s1 = firstFibDigits.call(n, nd2)
    if (s1.count < 20) {
        Fmt.print("  All $-2d   : $s", s1.count, s1)
    } else {
        Fmt.print("  First 20 : $s", s1)
        var s2 = lastFibDigits.call(nn, nd3)
        if (s2.count < 20) {
             Fmt.print("  Final $-2d : $s", s2.count, s2)
        } else {
            Fmt.print("  Final 20 : $s", s2)
        }
    }
    i = i * 10
}
var ord = ["th", "nd", "th"]
i = 0
for (p in [16, 32, 64]) {
    n.lsh(one, p)
    var nn = one << p
    Fmt.print("\nThe digits of the 2^$d$s Fibonacci number are:", p, ord[i])
    Fmt.print("  First $d : $s", nd, firstFibDigits.call(n, nd))
    Fmt.print("  Final $d : $s", nd, lastFibDigits.call(nn, nd))
    i = i + 1
}
System.print("\nTook %(System.clock-start) seconds.")
