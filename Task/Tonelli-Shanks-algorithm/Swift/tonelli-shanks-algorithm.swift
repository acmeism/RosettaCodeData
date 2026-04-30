import Foundation

struct Pair {
    let n: UInt64
    let p: UInt64
}

struct Solution {
    let root1: UInt64
    let root2: UInt64
    let isSquare: Bool
}

func multiplyModulus(_ a: UInt64, _ b: UInt64, modulus: UInt64) -> UInt64 {
    var a = a % modulus
    var b = b % modulus

    if b < a {
        swap(&a, &b)
    }

    var result: UInt64 = 0
    while a > 0 {
        if a % 2 == 1 {
            result = (result + b) % modulus
        }
        b = (b << 1) % modulus
        a >>= 1
    }
    return result
}

func powerModulus(_ base: UInt64, _ exponent: UInt64, modulus: UInt64) -> UInt64 {
    if modulus == 1 {
        return 0
    }

    var base = base % modulus
    var result: UInt64 = 1
    var exponent = exponent

    while exponent > 0 {
        if (exponent & 1) == 1 {
            result = multiplyModulus(result, base, modulus: modulus)
        }
        base = multiplyModulus(base, base, modulus: modulus)
        exponent >>= 1
    }
    return result
}

func legendre(_ a: UInt64, _ p: UInt64) -> UInt64 {
    return powerModulus(a, (p - 1) / 2, modulus: p)
}

func tonelliShanks(_ n: UInt64, _ p: UInt64) -> Solution {
    if legendre(n, p) != 1 {
        return Solution(root1: 0, root2: 0, isSquare: false)
    }

    // Factor out powers of 2 from p - 1
    var q = p - 1
    var s: UInt64 = 0
    while q % 2 == 0 {
        q /= 2
        s += 1
    }

    if s == 1 {
        let result = powerModulus(n, (p + 1) / 4, modulus: p)
        return Solution(root1: result, root2: p - result, isSquare: true)
    }

    // Find a non-square z such as ( z | p ) = -1
    var z: UInt64 = 2
    while legendre(z, p) != p - 1 {
        z += 1
    }

    var c = powerModulus(z, q, modulus: p)
    var t = powerModulus(n, q, modulus: p)
    var m = s
    var result = powerModulus(n, (q + 1) >> 1, modulus: p)

    while t != 1 {
        var i: UInt64 = 1
        var z = multiplyModulus(t, t, modulus: p)
        while z != 1 && i < m - 1 {
            i += 1
            z = multiplyModulus(z, z, modulus: p)
        }
        let b = powerModulus(c, 1 << (m - i - 1), modulus: p)
        c = multiplyModulus(b, b, modulus: p)
        t = multiplyModulus(t, c, modulus: p)
        m = i
        result = multiplyModulus(result, b, modulus: p)
    }

    return Solution(root1: result, root2: p - result, isSquare: true)
}

let tests: [Pair] = [
    Pair(n: 10, p: 13),
    Pair(n: 56, p: 101),
    Pair(n: 1030, p: 1009),
    Pair(n: 1032, p: 1009),
    Pair(n: 44402, p: 100049),
    Pair(n: 665820697, p: 1000000009),
    Pair(n: 881398088036, p: 1000000000039)
]

for test in tests {
    let solution = tonelliShanks(test.n, test.p)
    print("n = \(test.n), p = \(test.p)", terminator: "")
    if solution.isSquare {
        print(" has solutions: \(solution.root1) and \(solution.root2)\n")
    } else {
        print(" has no solutions because n is not a square modulo p\n")
    }
}
