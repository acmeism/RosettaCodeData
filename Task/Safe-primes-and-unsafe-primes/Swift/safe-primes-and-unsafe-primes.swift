import Foundation

class PrimeSieve {
    var composite: [Bool]

    init(size: Int) {
        composite = Array(repeating: false, count: size/2)
        var p = 3
        while p * p <= size {
            if !composite[p/2 - 1] {
                let inc = p * 2
                var q = p * p
                while q <= size {
                    composite[q/2 - 1] = true
                    q += inc
                }
            }
            p += 2
        }
    }

    func isPrime(number: Int) -> Bool {
        if number < 2 {
            return false
        }
        if (number & 1) == 0 {
            return number == 2
        }
        return !composite[number/2 - 1]
    }
}

func commatize(_ number: Int) -> String {
    let n = NSNumber(value: number)
    return NumberFormatter.localizedString(from: n, number: .decimal)
}

let limit1 = 1000000
let limit2 = 10000000

class PrimeInfo {
    let maxPrint: Int
    var count1: Int
    var count2: Int
    var primes: [Int]

    init(maxPrint: Int) {
        self.maxPrint = maxPrint
        count1 = 0
        count2 = 0
        primes = []
    }

    func addPrime(prime: Int) {
        count2 += 1
        if prime < limit1 {
            count1 += 1
        }
        if count2 <= maxPrint {
            primes.append(prime)
        }
    }

    func printInfo(name: String) {
        print("First \(maxPrint) \(name) primes: \(primes)")
        print("Number of \(name) primes below \(commatize(limit1)): \(commatize(count1))")
        print("Number of \(name) primes below \(commatize(limit2)): \(commatize(count2))")
    }
}

var safePrimes = PrimeInfo(maxPrint: 35)
var unsafePrimes = PrimeInfo(maxPrint: 40)

let sieve = PrimeSieve(size: limit2)

for prime in 2..<limit2 {
    if sieve.isPrime(number: prime) {
        if sieve.isPrime(number: (prime - 1)/2) {
            safePrimes.addPrime(prime: prime)
        } else {
            unsafePrimes.addPrime(prime: prime)
        }
    }
}

safePrimes.printInfo(name: "safe")
unsafePrimes.printInfo(name: "unsafe")
