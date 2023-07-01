/* repunit_primes.wren */

import "./gmp" for Mpz
import "./math" for Int
import "./fmt" for Fmt
import "./str" for Str

var limit = 2700
var primes = Int.primeSieve(limit)

for (b in 2..36) {
    var rPrimes = []
    for (p in primes) {
        var s = Mpz.fromStr(Str.repeat("1", p), b)
        if (s.probPrime(15) > 0) rPrimes.add(p)
    }
    Fmt.print("Base $2d: $n", b, rPrimes)
}
