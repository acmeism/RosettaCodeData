import "/big" for BigInt, BigInts

var primes = [2, 3, 5].map { |p| BigInt.new(p) }.toList

var hamming = Fn.new { |size|
    if (size < 1) Fiber.abort("size must be at least 1")
    var ns = List.filled(size, null)
    ns[0] = BigInt.one
    var next = primes.toList
    var indices = List.filled(3, 0)
    for (m in 1...size) {
        ns[m] = BigInts.min(next)
        for (i in 0..2) {
            if (ns[m] == next[i]) {
                indices[i] = indices[i] + 1
                next[i] = primes[i] * ns[indices[i]]
            }
        }
    }
    return ns
}

var h = hamming.call(1e6)
System.print("The first 20 Hamming numbers are:")
System.print(h[0..19])
System.print()
System.print("The 1,691st Hamming number is:")
System.print(h[1690])
System.print()
System.print("The 1,000,000th Hamming number is:")
System.print(h[999999])
