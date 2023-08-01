import "./big" for BigInt

var zero = BigInt.zero
var one  = BigInt.one
var two  = BigInt.two
var ten  = BigInt.ten
var k100 = BigInt.new(100000)

var smallestPrimeFactorWheel = Fn.new { |n, max|
    if (n.isProbablePrime(5)) return n
    if (n % 2 == zero) return BigInt.two
    if (n % 3 == zero) return BigInt.three
    if (n % 5 == zero) return BigInt.five
    var k = BigInt.new(7)
    var i = 0
    var inc = [4, 2, 4, 2, 4, 6, 2, 6]
    while (k * k <= n) {
        if (n % k == zero) return k
        k = k + inc[i]
        if (k > max) return null
        i = (i + 1) % 8
    }
}

var smallestPrimeFactor = Fn.new { |n|
    var s = smallestPrimeFactorWheel.call(n, k100)
    if (s) return s
    var c = one
    while (true) {
        var d = BigInt.pollardRho(n, 2, c)
        if (d == 0) {
            if (c == ten) Fiber.abort("Pollard Rho doesn't appear to be working.")
            c = c + one
        } else {
            // get the smallest prime factor of 'd'
            var factor = smallestPrimeFactorWheel.call(d, d)
            // check whether n/d has a smaller prime factor
            s = smallestPrimeFactorWheel.call(n/d, factor)
            return s ? BigInt.min(s, factor) : factor
        }
    }
}

var k = 16
System.print("First %(k) terms of the Euclid–Mullin sequence:")
System.print(2)
var prod = BigInt.two
var count = 1
while (count < k) {
    var t = smallestPrimeFactor.call(prod + one)
    System.print(t)
    prod = prod * t
    count = count + 1
}
