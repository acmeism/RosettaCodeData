import Foundation

func display(_ numbers: [Int32]) {
    let numbersStr = numbers.map { String($0) }.joined(separator: ", ")
    print("[\(numbersStr)]")
}

func stringSearchSingle(_ haystack: String, _ needle: String) -> Int32 {
    guard let range = haystack.range(of: needle) else {
        return -1
    }
    return Int32(haystack.distance(from: haystack.startIndex, to: range.lowerBound))
}

func stringSearch(_ haystack: String, _ needle: String) -> [Int32] {
    var result: [Int32] = []
    var start = 0
    var index: Int32 = 0

    while index >= 0 && start < haystack.count {
        let startIndex = haystack.index(haystack.startIndex, offsetBy: start)
        let haystackReduced = String(haystack[startIndex...])
        index = stringSearchSingle(haystackReduced, needle)

        if index >= 0 {
            result.append(Int32(start) + index)
            start += Int(index) + needle.count
        }
    }

    return result
}

func main() {
    let texts = [
        "GCTAGCTCTACGAGTCTA",
        "GGCTATAATGCGTA",
        "there would have been a time for such a word",
        "needle need noodle needle",
        "DKnuthusesandprogramsanimaginarycomputertheMIXanditsassociatedmachinecodeandassemblylanguages",
        "Nearby farms grew an acre of alfalfa on the dairy's behalf, with bales of that alfalfa exchanged for milk."
    ]

    let patterns = ["TCTA", "TAATAAA", "word", "needle", "and", "alfalfa"]

    for (i, text) in texts.enumerated() {
        print("text\(i + 1) = \(text)")
    }
    print()

    for (i, text) in texts.enumerated() {
        let indexes = stringSearch(text, patterns[i])
        print("Found \"\(patterns[i])\" in 'text\(i + 1)' at indexes ", terminator: "")
        display(indexes)
    }
}

// Call main function
main()
