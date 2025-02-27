import Foundation

// Moebius function
func mu(number: Int) -> Int {
    var n = number
    if n % 4 == 0 {
        return 0
    }
    var primeFactors = 0
    if n % 2 == 0 {
        primeFactors += 1
        n /= 2
    }
    var p = 3
    while p * p <= n {
        if n % p == 0 {
            n /= p
            if n % p == 0 {
                return 0
            }
            primeFactors += 1
        }
        p += 2
    }
    if (n > 1) {
        primeFactors += 1
    }
    return primeFactors % 2 == 0 ? 1 : -1
}

print("The first 199 Moebius numbers are:")
print("   ", terminator: "")
for i in 1..<200 {
    print(String(format: "%3d", mu(number: i)),
            terminator: (i + 1) % 20 == 0 ? "\n" : "")
}
