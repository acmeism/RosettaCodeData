import "/big" for BigInt

class PExp {
    construct new(prime, exp) {
        _prime = prime
        _exp = exp
    }
    prime { _prime }
    exp   { _exp }
}

var moBachShallit58 = Fn.new { |a, n, pf|
    var n1 = n - BigInt.one
    var mo = BigInt.one
    for (pe in pf) {
        var y = n1 / pe.prime.pow(pe.exp)
        var o = 0
        var x = a.modPow(y, n.abs)
        while (x > BigInt.one) {
            x = x.modPow(pe.prime, n.abs)
            o = o + 1
        }
        var o1 = BigInt.new(o)
        o1 = pe.prime.pow(o1)
        o1 = o1 / BigInt.gcd(mo, o1)
        mo = mo * o1
    }
    return mo
}

var factor = Fn.new { |n|
    var pf = []
    var nn = n.copy()
    var e = 0
    while (!nn.testBit(e)) e = e + 1
    if (e > 0) {
        nn = nn >> e
        pf.add(PExp.new(BigInt.two, e))
    }
    var s = nn.isqrt
    var d = BigInt.three
    while (nn > BigInt.one) {
        if (d > s) d = nn
        e = 0
        while (true) {
            var dm = nn.divMod(d)
            if (dm[1].bitLength > 0) break
            nn = dm[0]
            e = e + 1
        }
        if (e > 0) {
            pf.add(PExp.new(d, e))
            s = nn.isqrt
        }
        d = d + BigInt.two
    }
    return pf
}

var moTest = Fn.new { |a, n|
    if (!n.isProbablePrime(10)) {
        System.print("Not computed. Modulus must be prime for this algorithm.")
        return
    }
    System.write((a.bitLength < 100) ? "ord(%(a))"  : "ord([big])")
    System.write((n.bitLength < 100) ? " mod %(n) " : "mod([big])")
    var mob = moBachShallit58.call(a, n, factor.call(n - BigInt.one))
    System.print("= %(mob)")
}

moTest.call(BigInt.new(37), BigInt.new(3343))

var b = BigInt.ten.pow(100) + BigInt.one
moTest.call(b, BigInt.new(7919))

b = BigInt.ten.pow(1000) + BigInt.one
moTest.call(b, BigInt.new(15485863))

b = BigInt.ten.pow(10000) - BigInt.one
moTest.call(b, BigInt.new(22801763489))

moTest.call(BigInt.new(1511678068), BigInt.new(7379191741))
moTest.call(BigInt.new(3047753288), BigInt.new(2257683301))
