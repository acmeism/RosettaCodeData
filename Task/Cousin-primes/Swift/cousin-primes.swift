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
    var sq = p * p
    while sq < limit {
        if sieve[p] {
            for i in stride(from: sq, to: limit, by: p * 2) {
                sieve[i] = false
            }
        }
        sq += (p + 1) * 4;
        p += 2
    }
    return sieve
}

func toString(_ number: Int) -> String {
    return String(format: "%3d", number)
}

let limit = 1000
let sieve = primeSieve(limit: limit)
var count = 0
for p in 0..<limit - 4 {
    if sieve[p] && sieve[p + 4] {
        print("(\(toString(p)), \(toString(p + 4)))", terminator: "")
        count += 1
        print(count % 5 == 0 ? "\n" : " ", terminator: "")
    }
}
print("\nNumber of cousin prime pairs < \(limit): \(count)")
