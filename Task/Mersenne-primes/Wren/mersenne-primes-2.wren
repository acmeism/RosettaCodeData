import "./math" for Int
import "./gmp" for Mpz

var MAX = 23
System.print("The first %(MAX) Mersenne primes are:")
var count = 0
var p = 2
while (true) {
    var m = Mpz.one.lsh(p).sub(1)
    if (m.probPrime(15) > 0) {
        System.print("2 ^ %(p) - 1")
        count = count + 1
        if (count == MAX) break
    }
    while (true) {
        p = (p > 2) ? p + 2 : 3
        if (Int.isPrime(p)) break
    }
}
