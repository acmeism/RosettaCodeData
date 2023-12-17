/* Circular_primes_embedded.wren */

import "./gmp" for Mpz
import "./math" for Int
import "./fmt" for Fmt
import "./str" for Str

var circs = []

var isCircular = Fn.new { |n|
    var nn = n
    var pow = 1 // will eventually contain 10 ^ d where d is number of digits in n
    while (nn > 0) {
        pow = pow * 10
        nn = (nn/10).floor
    }
    nn = n
    while (true) {
        nn = nn * 10
        var f = (nn/pow).floor // first digit
        nn = nn + f * (1 - pow)
        if (circs.contains(nn)) return false
        if (nn == n) break
        if (!Int.isPrime(nn)) return false
    }
    return true
}

System.print("The first 19 circular primes are:")
var digits = [1, 3, 7, 9]
var q = [1, 2, 3, 5, 7, 9]  // queue the numbers to be examined
var fq = [1, 2, 3, 5, 7, 9] // also queue the corresponding first digits
var count = 0
while (true) {
    var f = q[0]   // peek first element
    var fd = fq[0] // peek first digit
    if (Int.isPrime(f) && isCircular.call(f)) {
        circs.add(f)
        count = count + 1
        if (count == 19) break
    }
    q.removeAt(0)  // pop first element
    fq.removeAt(0) // ditto for first digit queue
    if (f != 2 && f != 5) { // if digits > 1 can't contain a 2 or 5
        // add numbers with one more digit to queue
        // only numbers whose last digit >= first digit need be added
        for (d in digits) {
            if (d >= fd) {
                q.add(f*10+d)
                fq.add(fd)
            }
        }
    }
}
System.print(circs)

System.print("\nThe next 4 circular primes, in repunit format, are:")
count = 0
var rus = []
var primes = Int.primeSieve(10000)
var repunit = Mpz.new()
for (p in primes[3..-1]) {
    repunit.setStr(Str.repeat("1", p), 10)
    if (repunit.probPrime(10) > 0) {
       rus.add("R(%(p))")
       count = count + 1
       if (count == 4) break
    }
}
System.print(rus)
System.print("\nThe following repunits are probably circular primes:")
for (i in [5003, 9887, 15073, 25031, 35317, 49081]) {
    repunit.setStr(Str.repeat("1", i), 10)
    Fmt.print("R($-5d) : $s", i, repunit.probPrime(15) > 0)
}
