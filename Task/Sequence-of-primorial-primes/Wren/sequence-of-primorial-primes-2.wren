import "./gmp" for Mpz
import "./math" for Int
import "./fmt" for Fmt

var limit = 30
var c = 0
var i = 0
var primes = Int.primeSieve(9999) // more than enough
var p = Mpz.one
var two64 = Mpz.two.pow(64)
System.print("First %(limit) factorial primes:")
while (true) {
    var r = (p < two64) ? 1 : 0  // test for definite primeness below 2^64
    for (qs in [[p-1, "-"], [p+1, "+"]]) {
        if (qs[0].probPrime(15) > r) {
            var s = qs[0].toString
            var sc = s.count
            var digs = sc > 40 ? "(%(sc) digits)" : ""
            var pn = "p%(i)#"
            Fmt.print("$2d: $5s $s 1 = $20a $s", c = c + 1, pn, qs[1], s, digs)
            if (c == limit) return
        }
    }
    p.mul(primes[i])
    i = i + 1
}
