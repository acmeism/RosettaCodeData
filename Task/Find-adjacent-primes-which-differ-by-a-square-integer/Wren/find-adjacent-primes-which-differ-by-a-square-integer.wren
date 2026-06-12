import "./math" for Int
import "./fmt" for Fmt

var limit = 1e6 - 1
var primes = Int.primeSieve(limit)
System.print("Adjacent primes under 1,000,000 whose difference is a square > 36:")
for (i in 1...primes.count) {
    var diff = primes[i] - primes[i-1]
    if (diff > 36) {
        var s = diff.sqrt.floor
        if (diff == s * s) {
            Fmt.print ("$,7d - $,7d = $3d = $2d x $2d", primes[i], primes[i-1], diff, s, s)
        }
    }
}
