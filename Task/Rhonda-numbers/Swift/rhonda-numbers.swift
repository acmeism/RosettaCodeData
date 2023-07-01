func digitProduct(base: Int, num: Int) -> Int {
    var product = 1
    var n = num
    while n != 0 {
        product *= n % base
        n /= base
    }
    return product
}

func primeFactorSum(_ num: Int) -> Int {
    var sum = 0
    var n = num
    while (n & 1) == 0 {
        sum += 2
        n >>= 1
    }
    var p = 3
    while p * p <= n {
        while n % p == 0 {
            sum += p
            n /= p
        }
        p += 2
    }
    if n > 1 {
        sum += n
    }
    return sum
}

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

func isRhonda(base: Int, num: Int) -> Bool {
    return digitProduct(base: base, num: num) == base * primeFactorSum(num)
}

let limit = 15
for base in 2...36 {
    if isPrime(base) {
        continue
    }
    print("First \(limit) Rhonda numbers to base \(base):")
    let numbers = Array((1...).lazy.filter{ isRhonda(base: base, num: $0) }.prefix(limit))
    print("In base 10:", terminator: "")
    for n in numbers {
        print(" \(n)", terminator: "")
    }
    print("\nIn base \(base):", terminator: "")
    for n in numbers {
        print(" \(String(n, radix: base))", terminator: "")
    }
    print("\n")
}
