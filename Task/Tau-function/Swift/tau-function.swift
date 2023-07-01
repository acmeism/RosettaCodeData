import Foundation

// See https://en.wikipedia.org/wiki/Divisor_function
func divisorCount(number: Int) -> Int {
    var n = number
    var total = 1
    // Deal with powers of 2 first
    while (n & 1) == 0 {
        total += 1
        n >>= 1
    }
    // Odd prime factors up to the square root
    var p = 3
    while p * p <= n {
        var count = 1
        while n % p == 0 {
            count += 1
            n /= p
        }
        total *= count
        p += 2
    }
    // If n > 1 then it's prime
    if n > 1 {
        total *= 2
    }
    return total
}

let limit = 100
print("Count of divisors for the first \(limit) positive integers:")
for n in 1...limit {
    print(String(format: "%3d", divisorCount(number: n)), terminator: "")
    if n % 20 == 0 {
        print()
    }
}
