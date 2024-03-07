import Foundation

class JordanPolyaNumbers {

    static var jordanPolyaSet = Set<Int64>()
    static var decompositions = [Int64: [Int: Int]]()

    static func main() {
        createJordanPolya()

        let belowHundredMillion = jordanPolyaSet.filter { $0 <= 100_000_000 }.max() ?? 0
        let jordanPolya = Array(jordanPolyaSet).sorted()

        print("The first 50 Jordan-Polya numbers:")
        for i in 0..<50 {
            if i % 10 == 9 {
                print("\(jordanPolya[i])\n", terminator: "")
            } else {
                print(String(format: "%5d ", jordanPolya[i]), terminator: "")
            }
        }
        print("\nThe largest Jordan-Polya number less than 100 million: \(belowHundredMillion)\n")

        for i in [800, 1050, 1800, 2800, 3800] {
            print("The \(i)th Jordan-Polya number is: \(jordanPolya[i - 1]) = \(toString(decompositions[jordanPolya[i - 1]] ?? [:]))")
        }
    }

    static func createJordanPolya() {
        jordanPolyaSet.insert(1)
        var nextSet = Set<Int64>()
        decompositions[1] = [:]
        var factorial: Int64 = 1

        for multiplier in 2...20 {
            factorial *= Int64(multiplier)
            for number in jordanPolyaSet {
                var current = number
                while current <= Int64.max / factorial {
                    let original = current
                    current *= factorial
                    nextSet.insert(current)
                    decompositions[current] = decompositions[original]?.merging([multiplier: 1], uniquingKeysWith: +) ?? [:]
                }
            }
            jordanPolyaSet.formUnion(nextSet)
            nextSet.removeAll()
        }
    }

    static func toString(_ aMap: [Int: Int]) -> String {
        var result = ""
        for key in aMap.keys.sorted().reversed() {
            let value = aMap[key] ?? 0
            result += "\(key)!" + (value == 1 ? "" : "^\(value)") + " * "
        }
        return String(result.dropLast(3))
    }
}

JordanPolyaNumbers.main()
