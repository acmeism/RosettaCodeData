import Foundation

// MARK: - Day Enum
enum Day: String, CaseIterable, Comparable {
    static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.index < rhs.index
    }

    private var index: Int {
        switch self {
        case .monday: return 0
        case .tuesday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
        }
    }

    case monday = "MONDAY"
    case tuesday = "TUESDAY"
    case wednesday = "WEDNESDAY"
    case thursday = "THURSDAY"
    case friday = "FRIDAY"
    case saturday = "SATURDAY"
    case sunday = "SUNDAY"

    var letters: String {
        switch self {
        case .monday: return "HANDYCOILSERUPT"
        case .tuesday: return "SPOILUNDERYACHT"
        case .wednesday: return "DRAINSTYLEPOUCH"
        case .thursday: return "DITCHSYRUPALONE"
        case .friday: return "SOAPYTHIRDUNCLE"
        case .saturday: return "SHINEPARTYCLOUD"
        case .sunday: return "RADIOLUNCHTYPES"
        }
    }

    func previous() -> Day {
        let allDays = Day.allCases
        let currentIndex = allDays.firstIndex(of: self)!
        let previousIndex = (currentIndex - 1 + allDays.count) % allDays.count
        return allDays[previousIndex]
    }
}

// MARK: - Permutation Class
class Permutation {
    private let lettersCount: Int

    init(_ lettersCount: Int) {
        self.lettersCount = lettersCount
    }

    // Return the permutation in one line form that transforms the string 'source' into the string 'destination'.
    func createOneLine(source: String, destination: String) -> [Int] {
        var result: [Int] = []
        for ch in destination {
            if let index = source.firstIndex(of: ch) {
                result.append(source.distance(from: source.startIndex, to: index) + 1)
            }
        }

        while !result.isEmpty && result.last == result.count {
            result.removeLast()
        }

        return result
    }

    // Return the cycles of the permutation given in one line form.
    func oneLineToCycles(_ oneLine: [Int]) -> [[Int]] {
        var cycles: [[Int]] = []
        var used: Set<Int> = []

        var number = 1
        while used.count < oneLine.count {
            if !used.contains(number) {
                if let indexInOneLine = oneLine.firstIndex(of: number) {
                    let index = indexInOneLine + 1 // 1-based index
                    if index > 0 {
                        var cycle: [Int] = [number]
                        var currentIndex = index

                        while number != currentIndex {
                            cycle.append(currentIndex)
                            if let nextIndexInOneLine = oneLine.firstIndex(of: currentIndex) {
                                currentIndex = nextIndexInOneLine + 1 // 1-based index
                            } else {
                                break // Should not happen if oneLine is valid
                            }
                        }

                        if cycle.count > 1 {
                            cycles.append(cycle)
                        }
                        used.formUnion(cycle)
                    }
                }
            }
            number += 1
        }

        return cycles
    }

    // Return the one line notation of the permutation given in cycle form.
    func cyclesToOneLine(_ cycles: [[Int]]) -> [Int] {
        var oneLine = Array(1...lettersCount)

        for number in 1...lettersCount {
            for cycle in cycles {
                if let index = cycle.firstIndex(of: number) {
                    let prevIndex = (index - 1 + cycle.count) % cycle.count
                    oneLine[number - 1] = cycle[prevIndex]
                    break
                }
            }
        }

        return oneLine
    }

    // Return the inverse of the given permutation in cycle form.
    func cyclesInverse(_ cycles: [[Int]]) -> [[Int]] {
        var cyclesInverse = cycles.map { $0 }

        for i in 0..<cyclesInverse.count {
            cyclesInverse[i].append(cyclesInverse[i].removeFirst())
            cyclesInverse[i].reverse()
        }

        return cyclesInverse
    }

    // Return the inverse of the given permutation in one line notation.
    func oneLineInverse(_ oneLine: [Int]) -> [Int] {
        var oneLineInverse = Array(repeating: 0, count: oneLine.count)

        for (i, value) in oneLine.enumerated() {
            let number = i + 1 // 1-based index of position
            if value >= 1 && value <= oneLine.count {
                oneLineInverse[value - 1] = number
            }
        }

        return oneLineInverse
    }

    // Return the cycles obtained by composing cycleOne first followed by cycleTwo.
    func combinedCycles(_ cyclesOne: [[Int]], _ cyclesTwo: [[Int]]) -> [[Int]] {
        var combinedCycles: [[Int]] = []
        var used: Set<Int> = []

        var number = 1
        while used.count < lettersCount {
            if !used.contains(number) {
                let nextOne = next(number, in: cyclesOne)
                let combined = next(nextOne, in: cyclesTwo)

                var cycle: [Int] = [number]
                var currentCombined = combined

                while number != currentCombined {
                    cycle.append(currentCombined)
                    let nextOneInner = next(currentCombined, in: cyclesOne)
                    currentCombined = next(nextOneInner, in: cyclesTwo)
                }

                if cycle.count > 1 {
                    combinedCycles.append(cycle)
                }
                used.formUnion(cycle)
            }
            number += 1
        }

        return combinedCycles
    }

    // Return the given string permuted by the permutation given in one line form.
    func oneLinePermuteString(_ text: String, _ oneLine: [Int]) -> String {
        var permuted: [String] = []

        for index in oneLine {
            let textIndex = text.index(text.startIndex, offsetBy: index - 1)
            permuted.append(String(text[textIndex]))
        }

        // Append the remaining part of the string that wasn't permuted
        if permuted.count < text.count {
            let startIndex = text.index(text.startIndex, offsetBy: permuted.count)
            permuted.append(String(text[startIndex...]))
        }

        return permuted.joined()
    }

    // Return the given string permuted by the permutation given in cycle form.
    func cyclesPermuteString(_ text: String, _ cycles: [[Int]]) -> String {
        var permuted = Array(text)

        for cycle in cycles {
            for (i, number) in cycle.enumerated() {
                let nextIndexInCycle = (i + 1) % cycle.count
                let nextNumber = cycle[nextIndexInCycle]

                if number >= 1 && number <= text.count && nextNumber >= 1 && nextNumber <= text.count {
                    let sourceIndex = text.index(text.startIndex, offsetBy: number - 1)
                    let targetIndex = nextNumber - 1
                    permuted[targetIndex] = text[sourceIndex]
                }
            }
        }

        return String(permuted)
    }

    // Return the signature of the permutation given in one line form.
    func signature(_ oneLine: [Int]) -> String {
        let cycles = oneLineToCycles(oneLine)
        let evenCount = cycles.filter { $0.count % 2 == 0 }.count
        return (evenCount % 2 == 0) ? "+1" : "-1"
    }

    // Return the order of the permutation given in one line form.
    func order(_ oneLine: [Int]) -> Int {
        let cycles = oneLineToCycles(oneLine)
        let sizes = cycles.map { $0.count }

        return sizes.reduce(1) { (acc, size) in
            let gcdValue = gcd(acc, size)
            return acc * (size / gcdValue)
        }
    }

    // MARK: - Private Helpers

    // Return the element to which the given number is mapped by the permutation given in cycle form.
    private func next(_ number: Int, in cycles: [[Int]]) -> Int {
        for cycle in cycles {
            if let index = cycle.firstIndex(of: number) {
                let nextIndex = (index + 1) % cycle.count
                return cycle[nextIndex]
            }
        }
        return number
    }

    // Return the greatest common divisor of the two given numbers.
    private func gcd(_ one: Int, _ two: Int) -> Int {
        return (two == 0) ? one : gcd(two, one % two)
    }
}




// MARK: - Main Execution
func main() {
    let permutation = Permutation(Day.monday.letters.count)

    print("On Thursdays Alf and Betty should rearrange their letters using these cycles:")
    let oneLineWedThu = permutation.createOneLine(source: Day.wednesday.letters, destination: Day.thursday.letters)
    let cyclesWedThu = permutation.oneLineToCycles(oneLineWedThu)
    print(cyclesWedThu)
    print("So that \(Day.wednesday.letters) becomes \(Day.thursday.letters)")

    print("\nOr they could use the one line notation:")
    print(oneLineWedThu)

    print("\nTo revert to the Wednesday arrangement they should use these cycles:")
    let cyclesThuWed = permutation.cyclesInverse(cyclesWedThu)
    print(cyclesThuWed)

    print("\nOr with the one line notation:")
    let oneLineThuWed = permutation.oneLineInverse(oneLineWedThu)
    print(oneLineThuWed)
    print("So that \(Day.thursday.letters) becomes \(permutation.oneLinePermuteString(Day.thursday.letters, oneLineThuWed))")

    print("\nStarting with the Sunday arrangement and applying each of the daily")
    print("arrangements consecutively, the arrangements will be:\n")
    print("       \(Day.sunday.letters)\n")

    for day in Day.allCases {
        let dayOneLine = permutation.createOneLine(source: day.previous().letters, destination: day.letters)
        let result = permutation.oneLinePermuteString(day.previous().letters, dayOneLine)
        let suffix = (day == .saturday) ? "\n" : ""
        // Use Swift string interpolation instead of String(format:)
        print("\(day.rawValue):".padding(toLength: 11, withPad: " ", startingAt: 0) + result + suffix)
    }

    print("\nTo go from Wednesday to Friday in a single step they should use these cycles:")
    let oneLineThuFri = permutation.createOneLine(source: Day.thursday.letters, destination: Day.friday.letters)
    let cyclesThuFri = permutation.oneLineToCycles(oneLineThuFri)
    let cyclesWedFri = permutation.combinedCycles(cyclesWedThu, cyclesThuFri)
    print(cyclesWedFri)
    print("So that \(Day.wednesday.letters) becomes \(permutation.cyclesPermuteString(Day.wednesday.letters, cyclesWedFri))")

    print("\nThese are the signatures of the permutations:\n")
    for day in Day.allCases {
        let oneLine = permutation.createOneLine(source: day.previous().letters, destination: day.letters)
        // Use Swift string interpolation
        print("\(day.rawValue):".padding(toLength: 11, withPad: " ", startingAt: 0) + permutation.signature(oneLine))
    }

    print("\nThese are the orders of the permutations:\n")
    for day in Day.allCases {
        let oneLine = permutation.createOneLine(source: day.previous().letters, destination: day.letters)
        // Use Swift string interpolation
        print("\(day.rawValue):".padding(toLength: 11, withPad: " ", startingAt: 0) + "\(permutation.order(oneLine))")
    }

    print("\nApplying the Friday cycle to a string 10 times:")
    var word = "STOREDAILYPUNCH"
    print("\n 0 \(word)\n")
    for i in 1...10 {
        word = permutation.cyclesPermuteString(word, cyclesThuFri)
        let suffix = (i == 9) ? "\n" : ""
        // Use Swift string interpolation and padding
        print("\(String(format: "%2d", i)) \(word)\(suffix)")
    }
}


main()
