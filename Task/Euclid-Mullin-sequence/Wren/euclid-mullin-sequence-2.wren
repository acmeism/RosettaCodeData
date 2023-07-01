/* euclid_mullin_gmp.wren */

import "./gmp" for Mpz

var max = Mpz.from(100000)

var smallestPrimeFactorWheel = Fn.new { |n|
    if (n.probPrime(15) > 0) return n
    if (n.isEven) return Mpz.two
    if (n.isDivisibleUi(3)) return Mpz.three
    if (n.isDivisibleUi(5)) return Mpz.five
    var k = Mpz.from(7)
    var i = 0
    var inc = [4, 2, 4, 2, 4, 6, 2, 6]
    while (k * k <= n) {
        if (n.isDivisible(k)) return k
        k.add(inc[i])
        if (k > max) return null
        i = (i + 1) % 8
    }
}

var smallestPrimeFactor = Fn.new { |n|
    var s = smallestPrimeFactorWheel.call(n)
    if (s) return s
    var c = Mpz.one
    s = n.copy()
    while (n > max) {
        var d = Mpz.pollardRho(n, 2, c)
        if (d.isZero) {
            if (c == 100) Fiber.abort("Pollard Rho doesn't appear to be working.")
            c.inc
        } else {
            // can't be sure PR will find the smallest prime factor first
            s.min(d)
            n.div(d)
            if (n.probPrime(5) > 0) return Mpz.min(s, n)
        }
    }
    return s
}

var k = 19
System.print("First %(k) terms of the Euclid–Mullin sequence:")
System.print(2)
var prod = Mpz.two
var count = 1
while (count < k) {
    var t = smallestPrimeFactor.call(prod + Mpz.one)
    System.print(t)
    prod.mul(t)
    count = count + 1
}
