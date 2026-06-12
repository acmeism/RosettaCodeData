import "./gmp" for Mpz
import "./fmt" for Fmt

var fact = Mpz.one
var p = Mpz.new()
var diffs = List.filled(50, 0)
var n = 0
var t = 1000
var limit = 10000
while (true) {
    if (n > 0) fact.mul(n)
    p.nextPrime(fact)
    var m = p.sub(fact).toNum
    if (n < 50) diffs[n] = m
    if (n == 49) {
        System.print("Least positive m such that n! + m is prime; first 50:")
        Fmt.tprint("$3d ", diffs, 10)
        System.print()
    } else if (m > t) {
        while (true) {
            Fmt.print("First m > $,6d is $,6d at position $d", t, m, n)
            t = t + 1000
            if (m <= t) break
        }
        if (t > limit) return
    }
    n = n + 1
}
