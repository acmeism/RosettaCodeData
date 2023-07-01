import "./math" for Int
import "./gmp" for Mpz
import "./fmt" for Fmt

var isWagstaff = Fn.new { |p|
    var w = (2.pow(p) + 1) / 3  // always integral
    if (!Int.isPrime(w)) return [false, null]
    return [true, [p, w]]
}

var isBigWagstaff = Fn.new { |p|
    var w = Mpz.one.lsh(p).add(1).div(3)
    return w.probPrime(15) > 0
}

var start = System.clock
var p = 1
var wagstaff = []
while (wagstaff.count < 10) {
    while (true) {
        p = p + 2
        if (Int.isPrime(p)) break
    }
    var res = isWagstaff.call(p)
    if (res[0]) wagstaff.add(res[1])
}
System.print("First 10 Wagstaff primes for the values of 'p' shown:")
for (i in 0..9) Fmt.print("$2d: $d", wagstaff[i][0], wagstaff[i][1])
System.print("\nTook %(System.clock - start) seconds")

var limit = 19
var count = 0
System.print("\nValues of 'p' for the next %(limit) Wagstaff primes and")
System.print("overall time taken to reach them to higher second:")
while (count < limit) {
    while (true) {
        p = p + 2
        if (Int.isPrime(p)) break
    }
    if (isBigWagstaff.call(p)) {
        Fmt.print("$5d ($3d secs)", p, (System.clock - start).ceil)
        count = count + 1
    }
}
