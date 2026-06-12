import "./math" for Int
import "./fmt" for Fmt

var max = 1e7 - 1
var primes = Int.primeSieve(max)

var specialNP = Fn.new { |limit, showAll|
    if (showAll) System.print("Neighbor primes, p1 and p2, where p1 + p2 - 1 is prime:")
    var count = 0
    var p3
    for (i in 1...primes.where { |p| p < limit }.count) {
        var p2 = primes[i]
        var p1 = primes[i-1]
        if (Int.isPrime(p3 = p1 + p2 - 1)) {
            if (showAll) Fmt.print("($2d, $2d) => $3d", p1, p2, p3)
            count = count + 1
        }
    }
    Fmt.print("\nFound $,d special neighbor primes under $,d.", count, limit)
}

specialNP.call(100, true)
for (i in 3..7) {
    specialNP.call(10.pow(i), false)
}
