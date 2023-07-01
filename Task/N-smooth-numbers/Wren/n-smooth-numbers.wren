import "/math" for Int
import "/big" for BigInt, BigInts

// cache all primes up to 521
var smallPrimes = Int.primeSieve(521)
var primes = smallPrimes.map { |p| BigInt.new(p) }.toList

var nSmooth = Fn.new { |n, size|
    if (n < 2 || n > 521) Fiber.abort("n must be between 2 and 521")
    if (size < 1) Fiber.abort("size must be at least 1")
    var bn = BigInt.new(n)
    var ok = false
    for (prime in primes) {
        if (bn == prime) {
            ok = true
            break
        }
    }
    if (!ok) Fiber.abort("n must be a prime number")
    var ns = List.filled(size, null)
    ns[0] = BigInt.one
    var next = []
    for (i in 0...primes.count) {
        if (primes[i] > bn) break
        next.add(primes[i])
    }
    var indices = List.filled(next.count, 0)
    for (m in 1...size) {
        ns[m] = BigInts.min(next)
        for (i in 0...indices.count) {
            if (ns[m] == next[i]) {
                indices[i] = indices[i] + 1
                next[i] = primes[i] * ns[indices[i]]
            }
        }
    }
    return ns
}

smallPrimes = smallPrimes.where { |p| p <= 29 }
for (i in smallPrimes) {
    System.print("The first 25 %(i)-smooth numbers are:")
    System.print(nSmooth.call(i, 25))
    System.print()
}
for (i in smallPrimes.skip(1)) {
    System.print("The 3,000th to 3,202nd %(i)-smooth numbers are:")
    System.print(nSmooth.call(i, 3002)[2999..-1])
    System.print()
}
for (i in [503, 509, 521]) {
    System.print("The 30,000th to 30,019th %(i)-smooth numbers are:")
    System.print(nSmooth.call(i, 30019)[29999..-1])
    System.print()
}
