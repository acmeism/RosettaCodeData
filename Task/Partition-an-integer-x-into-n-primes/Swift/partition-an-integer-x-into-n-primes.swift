import Foundation

class BitArray {
    var array: [UInt32]

    init(size: Int) {
        array = Array(repeating: 0, count: (size + 31)/32)
    }

    func get(index: Int) -> Bool {
        let bit = UInt32(1) << (index & 31)
        return (array[index >> 5] & bit) != 0
    }

    func set(index: Int, value: Bool) {
        let bit = UInt32(1) << (index & 31)
        if value {
            array[index >> 5] |= bit
        } else {
            array[index >> 5] &= ~bit
        }
    }
}

class PrimeSieve {
    let composite: BitArray

    init(size: Int) {
        composite = BitArray(size: size/2)
        var p = 3
        while p * p <= size {
            if !composite.get(index: p/2 - 1) {
                let inc = p * 2
                var q = p * p
                while q <= size {
                    composite.set(index: q/2 - 1, value: true)
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
        return !composite.get(index: number/2 - 1)
    }
}

func findPrimePartition(sieve: PrimeSieve, number: Int,
                        count: Int, minPrime: Int,
                        primes: inout [Int], index: Int) -> Bool {
    if count == 1 {
        if number >= minPrime && sieve.isPrime(number: number) {
            primes[index] = number
            return true
        }
        return false
    }
    if minPrime >= number {
        return false
    }
    for p in minPrime..<number {
        if sieve.isPrime(number: p)
            && findPrimePartition(sieve: sieve, number: number - p,
                                  count: count - 1, minPrime: p + 1,
                                  primes: &primes, index: index + 1) {
            primes[index] = p
            return true
        }
    }
    return false
}

func printPrimePartition(sieve: PrimeSieve, number: Int, count: Int) {
    var primes = Array(repeating: 0, count: count)
    if !findPrimePartition(sieve: sieve, number: number, count: count,
                           minPrime: 2, primes: &primes, index: 0) {
        print("\(number) cannot be partitioned into \(count) primes.")
    } else {
        print("\(number) = \(primes[0])", terminator: "")
        for i in 1..<count {
            print(" + \(primes[i])", terminator: "")
        }
        print()
    }
}

let sieve = PrimeSieve(size: 100000)
printPrimePartition(sieve: sieve, number: 99809, count: 1)
printPrimePartition(sieve: sieve, number: 18, count: 2)
printPrimePartition(sieve: sieve, number: 19, count: 3)
printPrimePartition(sieve: sieve, number: 20, count: 4)
printPrimePartition(sieve: sieve, number: 2017, count: 24)
printPrimePartition(sieve: sieve, number: 22699, count: 1)
printPrimePartition(sieve: sieve, number: 22699, count: 2)
printPrimePartition(sieve: sieve, number: 22699, count: 3)
printPrimePartition(sieve: sieve, number: 22699, count: 4)
printPrimePartition(sieve: sieve, number: 40355, count: 3)
