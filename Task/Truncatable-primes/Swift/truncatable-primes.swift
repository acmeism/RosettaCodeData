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

func isLeftTruncatable(_ p: Int) -> Bool {
    var n = 10
    var q = p
    while p > n {
        if !isPrime(p % n) || q == p % n {
            return false
        }
        q = p % n
        n *= 10
    }
    return true
}

func isRightTruncatable(_ p: Int) -> Bool {
    var q = p / 10
    while q > 0 {
        if !isPrime(q) {
            return false
        }
        q /= 10
    }
    return true
}

let limit = 1000000
var largestLeft = 0
var largestRight = 0
var p = limit
while p >= 2 {
    if isPrime(p) && isLeftTruncatable(p) {
        largestLeft = p
        break
    }
    p -= 1
}
print("Largest left truncatable prime is \(largestLeft)")
p = limit
while p >= 2 {
    if isPrime(p) && isRightTruncatable(p) {
        largestRight = p
        break
    }
    p -= 1
}
print("Largest right truncatable prime is \(largestRight)")
