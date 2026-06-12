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

for n in 1...200 {
    let p = n * n * n + 2
    if isPrime(p) {
        print(String(format: "%3d%9d", n, p))
    }
}
