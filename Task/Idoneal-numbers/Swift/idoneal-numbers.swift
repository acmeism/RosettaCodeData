import Foundation

func isIdoneal(_ n: Int) -> Bool {
    for a in 1..<n {
        for b in a + 1..<n {
            if a * b + a + b > n {
                break
            }
            for c in b + 1..<n {
                let sum = a * b + b * c + a * c
                if sum == n {
                    return false
                }
                if sum > n {
                    break
                }
            }
        }
    }
    return true
}

var count = 0
for n in 1..<1850 {
    if isIdoneal(n) {
        count += 1
        print(String(format: "%4d", n), terminator: count % 13 == 0 ? "\n" : " ")
    }
}
