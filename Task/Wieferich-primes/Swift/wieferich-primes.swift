func primeSieve(limit: Int) -> [Bool] {
    guard limit > 0 else {
        return []
    }
    var sieve = Array(repeating: true, count: limit)
    sieve[0] = false
    if limit > 1 {
        sieve[1] = false
    }
    if limit > 4 {
        for i in stride(from: 4, to: limit, by: 2) {
            sieve[i] = false
        }
    }
    var p = 3
    while true {
        var q = p * p
        if q >= limit {
            break
        }
        if sieve[p] {
            let inc = 2 * p
            while q < limit {
                sieve[q] = false
                q += inc
            }
        }
        p += 2
    }
    return sieve
}

func modpow(base: Int, exponent: Int, mod: Int) -> Int {
    if mod == 1 {
        return 0
    }
    var result = 1
    var exp = exponent
    var b = base
    b %= mod
    while exp > 0 {
        if (exp & 1) == 1 {
            result = (result * b) % mod
        }
        b = (b * b) % mod
        exp >>= 1
    }
    return result
}

func wieferichPrimes(limit: Int) -> [Int] {
    let sieve = primeSieve(limit: limit)
    var result: [Int] = []
    for p in 2..<limit {
        if sieve[p] && modpow(base: 2, exponent: p - 1, mod: p * p) == 1 {
            result.append(p)
        }
    }
    return result
}

let limit = 5000
print("Wieferich primes less than \(limit):")
for p in wieferichPrimes(limit: limit) {
    print(p)
}
