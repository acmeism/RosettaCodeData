import Foundation

func isPrime(_ n: Int) -> Bool {
    if n < 2 {
        return false
    }
    if n % 2 == 0 {
        return n == 2
    }
    if n % 3 == 0 {
        return n == 3
    }
    var p = 5
    while p * p <= n {
        if n % p == 0 {
            return false
        }
        p += 2
        if n % p == 0 {
            return false
        }
        p += 4
    }
    return true
}

func digitSum(_ num: Int) -> Int {
    var sum = 0
    var n = num
    while n > 0 {
        sum += n % 10
        n /= 10
    }
    return sum
}

let limit = 500
print("Additive primes less than \(limit):")
var count = 0
for n in 1..<limit {
    if isPrime(digitSum(n)) && isPrime(n) {
        count += 1
        print(String(format: "%3d", n), terminator: count % 10 == 0 ? "\n" : " ")
    }
}
print("\n\(count) additive primes found.")
