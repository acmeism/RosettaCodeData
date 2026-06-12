import Foundation

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

func strangeUniquePrimeTriplets(limit: Int, verbose: Bool) {
    guard limit > 5 else {
        return;
    }
    let sieve = primeSieve(limit: 3 * limit)
    var primes: [Int] = []
    for p in stride(from: 3, to: limit, by: 2) {
        if sieve[p] {
            primes.append(p)
        }
    }
    let n = primes.count
    var count = 0
    if verbose {
        print("Strange unique prime triplets < \(limit):")
    }
    for i in (0..<n - 2) {
        for j in (i + 1..<n - 1) {
            for k in (j + 1..<n) {
                let sum = primes[i] + primes[j] + primes[k]
                if sieve[sum] {
                    count += 1
                    if verbose {
                        print(String(format: "%2d + %2d + %2d = %2d",
                                     primes[i], primes[j], primes[k], sum))
                    }
                }
            }
        }
    }
    print("\nCount of strange unique prime triplets < \(limit) is \(count).")
}

strangeUniquePrimeTriplets(limit: 30, verbose: true)
strangeUniquePrimeTriplets(limit: 1000, verbose: false)
