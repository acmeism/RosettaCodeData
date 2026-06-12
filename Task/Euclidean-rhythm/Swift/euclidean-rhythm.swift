import Foundation

class SequenceGenerator {

    static func generateSequence(k: Int, n: Int) -> String {
        var s = Array(repeating: [Int](), count: n)

        for i in 0..<n {
            if i < k {
                s[i].append(1)
            } else {
                s[i].append(0)
            }
        }

        var d = n - k
        var nVar = max(k, d)
        var kVar = min(k, d)
        var z = d

        while z > 0 || kVar > 1 {
            for i in 0..<kVar {
                s[i].append(contentsOf: s[s.count - 1 - i])
            }
            s = Array(s[0..<(s.count - kVar)])
            z -= kVar
            d = nVar - kVar
            nVar = max(kVar, d)
            kVar = min(kVar, d)
        }

        let result = s.flatMap { $0 }.map { String($0) }.joined()
        return result
    }
}

// Example usage
let result = SequenceGenerator.generateSequence(k: 5, n: 13)
print(result) // Should print 1001010010100
