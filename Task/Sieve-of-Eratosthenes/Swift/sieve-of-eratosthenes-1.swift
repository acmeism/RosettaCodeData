import Foundation // for sqrt() and Date()

let max = 1_000_000
let maxroot = Int(sqrt(Float80(max)))
let startingPoint = Date()

var isprime = [Bool](repeating: true, count: max+1 )
for i in 2...maxroot {
    if isprime[i] {
        for k in stride(from: max/i, through: i, by: -1) {
            if isprime[k] {
                isprime[i*k] = false }
        }
    }
}

var count = 0
for i in 2...max {
    if isprime[i] {
        count += 1
    }
}
print("\(count) primes found under \(max)")

print("\(startingPoint.timeIntervalSinceNow * -1) seconds")
