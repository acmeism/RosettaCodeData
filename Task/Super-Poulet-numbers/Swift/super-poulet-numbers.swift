func divisors(number: UInt32) -> [UInt32] {
    var result: [UInt32] = [1]
    var power: UInt32 = 2
    var n = number
    while (n & 1) == 0 {
        result.append(power)
        power <<= 1
        n >>= 1
    }
    var p: UInt32 = 3
    while p * p <= n {
        let size = result.count
        power = p
        while n % p == 0 {
            for i in 0..<size {
                result.append(power * result[i])
            }
            n /= p
            power *= p
        }
        p += 2
    }
    if n > 1 {
        let size = result.count
        for i in 0..<size {
            result.append(n * result[i])
        }
    }
    return result
}

func modPow(base: UInt64, exponent: UInt32, mod: UInt32) -> UInt64 {
    if mod == 1 {
        return 0
    }
    var result: UInt64 = 1
    var exp = exponent
    var b = base
    let m = UInt64(mod)
    b %= m
    while exp > 0 {
        if (exp & 1) == 1 {
            result = (result * b) % m
        }
        b = (b * b) % m
        exp >>= 1
    }
    return result
}

func isPrime(number: UInt32) -> Bool {
    if number < 2 {
        return false
    }
    if number % 2 == 0 {
        return number == 2
    }
    if number % 3 == 0 {
        return number == 3
    }
    if number % 5 == 0 {
        return number == 5
    }
    var p: UInt32 = 7
    let wheel: [UInt32] = [4,2,4,2,4,6,2,6]
    while true {
        for w in wheel {
            if p * p > number {
                return true
            }
            if number % p == 0 {
                return false
            }
            p += w
        }
    }
}

func isPouletNumber(_ n: UInt32) -> Bool {
    return modPow(base: 2, exponent: n - 1, mod: n) == 1 && !isPrime(number: n)
}

func isSuperPouletNumber(_ n: UInt32) -> Bool {
    if (!isPouletNumber(n)) {
        return false
    }
    let div = divisors(number: n)
    return div[1...].allSatisfy({modPow(base: 2, exponent: $0, mod: $0) == 2})
}

var n: UInt32 = 1
var count = 0

print("First 20 super-Poulet numbers:")
while count < 20 {
    if (isSuperPouletNumber(n)) {
        count += 1
        print("\(n)", terminator: " ")
    }
    n += 2
}
print()

var limit = 1000000
while limit <= 10000000 {
    while true {
        n += 2
        if (isSuperPouletNumber(n)) {
            count += 1
            if (n > limit) {
                break
            }
        }
    }
    print("\nIndex and value of first super-Poulet greater than \(limit):\n#\(count) is \(n)")
    limit *= 10
}
