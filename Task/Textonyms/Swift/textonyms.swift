import Foundation

func textCharacter(_ ch: Character) -> Character? {
    switch (ch) {
    case "a", "b", "c":
        return "2"
    case "d", "e", "f":
        return "3"
    case "g", "h", "i":
        return "4"
    case "j", "k", "l":
        return "5"
    case "m", "n", "o":
        return "6"
    case "p", "q", "r", "s":
        return "7"
    case "t", "u", "v":
        return "8"
    case "w", "x", "y", "z":
        return "9"
    default:
        return nil
    }
}

func textString(_ string: String) -> String? {
    var result = String()
    result.reserveCapacity(string.count)
    for ch in string {
        if let tch = textCharacter(ch) {
            result.append(tch)
        } else {
            return nil
        }
    }
    return result
}

func compareByWordCount(pair1: (key: String, value: [String]),
                        pair2: (key: String, value: [String])) -> Bool {
    if pair1.value.count == pair2.value.count {
        return pair1.key < pair2.key
    }
    return pair1.value.count > pair2.value.count
}

func compareByTextLength(pair1: (key: String, value: [String]),
                         pair2: (key: String, value: [String])) -> Bool {
    if pair1.key.count == pair2.key.count {
        return pair1.key < pair2.key
    }
    return pair1.key.count > pair2.key.count
}

func findTextonyms(_ path: String) throws {
    var dict = Dictionary<String, [String]>()
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    var count = 0
    for line in contents.components(separatedBy: "\n") {
        if line.isEmpty {
            continue
        }
        let word = line.lowercased()
        if let text = textString(word) {
            dict[text, default: []].append(word)
            count += 1
        }
    }
    var textonyms = Array(dict.filter{$0.1.count > 1})
    print("There are \(count) words in '\(path)' which can be represented by the digit key mapping.")
    print("They require \(dict.count) digit combinations to represent them.")
    print("\(textonyms.count) digit combinations represent Textonyms.")

    let top = min(5, textonyms.count)
    print("\nTop \(top) by number of words:")
    textonyms.sort(by: compareByWordCount)
    for (text, words) in textonyms.prefix(top) {
        print("\(text) = \(words.joined(separator: ", "))")
    }

    print("\nTop \(top) by length:")
    textonyms.sort(by: compareByTextLength)
    for (text, words) in textonyms.prefix(top) {
        print("\(text) = \(words.joined(separator: ", "))")
    }
}

do {
    try findTextonyms("unixdict.txt")
} catch {
    print(error.localizedDescription)
}
