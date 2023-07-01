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

// return number of decimal digits
func countDigits(number: Int) -> Int {
    var digits = 0
    var n = number
    while n > 0 {
        n /= 10
        digits += 1
    }
    return digits
}

// return the number with one digit replaced
func changeDigit(number: Int, index: Int, digit: Int) -> Int {
    var p = 1
    var changed = 0
    var n = number
    var i = index
    while i > 0 {
        changed += p * (n % 10)
        p *= 10
        n /= 10
        i -= 1
    }
    changed += (10 * (n / 10) + digit) * p
    return changed
}

func unprimeable(sieve: PrimeSieve, number: Int) -> Bool {
    if sieve.isPrime(number: number) {
        return false
    }
    for i in 0..<countDigits(number: number) {
        for j in 0..<10 {
            let n = changeDigit(number: number, index: i, digit: j)
            if n != number && sieve.isPrime(number: n) {
                return false
            }
        }
    }
    return true
}

var count = 0
var n = 100
var lowest = Array(repeating: 0, count: 10)
var found = 0
let sieve = PrimeSieve(size: 10000000)
print("First 35 unprimeable numbers:")
while count < 600 || found < 10 {
    if unprimeable(sieve: sieve, number: n) {
        if count < 35 {
            if count > 0 {
                print(", ", terminator: "")
            }
            print(n, terminator: "")
        }
        count += 1
        if count == 600 {
            print("\n600th unprimeable number: \(n)")
        }
        let lastDigit = n % 10
        if lowest[lastDigit] == 0 {
            lowest[lastDigit] = n
            found += 1
        }
    }
    n += 1
}
for i in 0..<10 {
    let number = NSNumber(value: lowest[i])
    let str = NumberFormatter.localizedString(from: number, number: .decimal)
    print("Least unprimeable number ending in \(i): \(str)")
}
