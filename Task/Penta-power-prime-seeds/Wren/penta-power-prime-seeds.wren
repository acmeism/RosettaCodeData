import "./gmp" for Mpz
import "./fmt" for Fmt

var p = Mpz.new()
var q = Mpz.one

var isPentaPowerPrimeSeed = Fn.new { |n|
    p.setUi(n)
    var k = n + 1
    return (q + k).probPrime(15) > 0 &&
           (p + k).probPrime(15) > 0 &&
           (p.mul(n) + k).probPrime(15) > 0 &&
           (p.mul(n) + k).probPrime(15) > 0 &&
           (p.mul(n) + k).probPrime(15) > 0
}

var ppps = []
var n = 1
while (ppps.count < 30) {
    if (isPentaPowerPrimeSeed.call(n)) ppps.add(n)
    n = n + 2  // n must be odd
}
System.print("First thirty penta-power prime seeds:")
Fmt.tprint("$,9d", ppps, 10)

System.print("\nFirst penta-power prime seed greater than:")
n = 1
var m = 1
var c = 0
while (true) {
    if (isPentaPowerPrimeSeed.call(n)) {
        c = c + 1
        if (n > m * 1e6) {
            Fmt.print(" $2d million is the $r: $,10d", m, c, n)
            m = m + 1
            if (m == 11) return
        }
    }
    n = n + 2
}
