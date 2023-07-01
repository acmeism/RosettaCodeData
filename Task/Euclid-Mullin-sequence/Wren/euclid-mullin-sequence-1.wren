import "./big" for BigInt

var zero = BigInt.zero
var one  = BigInt.one
var two  = BigInt.two
var ten  = BigInt.ten
var max  = BigInt.new(100000)

var pollardRho = Fn.new { |n, c|
    var g = Fn.new { |x, y| (x*x + c) % n }
    var x = two
    var y = two
    var z = one
    var d = max + one
    var count = 0
    while (true) {
        x = g.call(x, n)
        y = g.call(g.call(y, n), n)
        d = (x - y).abs % n
        z = z * d
        count = count + 1
        if (count == 100) {
            d = BigInt.gcd(z, n)
            if (d != one) break
            z = one
            count = 0
        }
    }
    if (d == n) return zero
    return d
}

var smallestPrimeFactorWheel = Fn.new { |n|
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
    var s = smallestPrimeFactorWheel.call(n)
    if (s) return s
    var c = one
    s = n
    while (n > max) {
        var d = pollardRho.call(n, c)
        if (d == 0) {
            if (c == ten) Fiber.abort("Pollard Rho doesn't appear to be working.")
            c = c + one
        } else {
            // can't be sure PR will find the smallest prime factor first
            s = BigInt.min(s, d)
            n = n / d
            if (n.isProbablePrime(2)) return BigInt.min(s, n)
        }
    }
    return s
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
