import "./gmp" for Mpz
import "./fmt" for Fmt

var limit = 33
var c = 0
var i = 1
var f = Mpz.one
System.print("First %(limit) factorial primes;")
while (true) {
    f.mul(i)
    var r = (i < 21) ? 1 : 0  // test for definite primeness below 2^64
    for (gs in [[f-1, "-"], [f+1, "+"]]) {
        if (gs[0].probPrime(15) > r) {
            var s = gs[0].toString
            var sc = s.count
            var digs = sc > 40 ? "(%(sc) digits)" : ""
            Fmt.print("$2d: $3d! $s 1 = $20a $s", c = c + 1, i, gs[1], s, digs)
            if (c == limit) return
        }
    }
    i = i + 1
}
