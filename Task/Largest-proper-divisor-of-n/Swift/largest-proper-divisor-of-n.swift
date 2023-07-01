import Foundation

func largestProperDivisor(_ n : Int) -> Int? {
    guard n > 0 else {
        return nil
    }
    if (n & 1) == 0 {
        return n >> 1
    }
    var p = 3
    while p * p <= n {
        if n % p == 0 {
            return n / p
        }
        p += 2
    }
    return 1
}

for n in (1..<101) {
    print(String(format: "%2d", largestProperDivisor(n)!),
          terminator: n % 10 == 0 ? "\n" : " ")
}
