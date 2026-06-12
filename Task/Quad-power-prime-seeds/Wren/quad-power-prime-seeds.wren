import "./gmp" for Mpz
import "./fmt" for Fmt

var p = Mpz.new()

var isQuadPowerPrimeSeed = Fn.new { |n|
    p.setUi(n)
    var k = n + 1
    return (p + k).probPrime(15) > 0 &&
           (p.mul(n) + k).probPrime(15) > 0 &&
           (p.mul(n) + k).probPrime(15) > 0 &&
           (p.mul(n) + k).probPrime(15) > 0
}

var qpps = []
var n = 1
while (qpps.count < 50) {
    if (isQuadPowerPrimeSeed.call(n)) qpps.add(n)
    n = n + 1
}
System.print("First fifty quad-power prime seeds:")
Fmt.tprint("$,7d", qpps, 10)

System.print("\nFirst quad-power prime seed greater than:")
var m = 1
var c = 50
while (true) {
    if (isQuadPowerPrimeSeed.call(n)) {
        c = c + 1
        if (n > m * 1e6) {
            Fmt.print(" $2d million is the $r: $,10d", m, c, n)
            m = m + 1
            if (m == 11) return
        }
    }
    n = n + 1
}
