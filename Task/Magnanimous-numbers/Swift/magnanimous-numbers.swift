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

func isMagnanimous(_ n: Int) -> Bool {
    var p = 10;
    while n >= p {
        if !isPrime(n % p + n / p) {
            return false
        }
        p *= 10
    }
    return true
}

let m = (0...).lazy.filter{isMagnanimous($0)}.prefix(400);
print("First 45 magnanimous numbers:");
for (i, n) in m.prefix(45).enumerated() {
    if i > 0 && i % 15 == 0 {
        print()
    }
    print(String(format: "%3d", n), terminator: " ")
}
print("\n\n241st through 250th magnanimous numbers:");
for n in m.dropFirst(240).prefix(10) {
    print(n, terminator: " ")
}
print("\n\n391st through 400th magnanimous numbers:");
for n in m.dropFirst(390) {
    print(n, terminator: " ")
}
print()
