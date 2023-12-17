/* Euclid_mullin_sequence_2.wren */

import "./gmp" for Mpz

var k100 = Mpz.from(100000)

var smallestPrimeFactorTrial = Fn.new { |n, max|
    if (n.probPrime(15) > 0) return n
    var k = Mpz.one
    while (k * k <= n) {
        k.nextPrime
        if (k > max) return null
        if (n.isDivisible(k)) return k
    }
}

var smallestPrimeFactor = Fn.new { |n|
    var s = smallestPrimeFactorTrial.call(n, k100)
    if (s) return s
    var c = Mpz.one
    while (true) {
        var d = Mpz.pollardRho(n, 2, c)
        if (d.isZero) {
            if (c == 100) Fiber.abort("Pollard Rho doesn't appear to be working.")
            c.inc
        } else {
            // get the smallest prime factor of 'd'
            var factor = smallestPrimeFactorTrial.call(d, d)
            // check whether n/d has a smaller prime factor
            s = smallestPrimeFactorTrial.call(n/d, factor)
            return s ? Mpz.min(s, factor) : factor
        }
    }
}

var k = 27
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
