import Foundation

func isVowel(_ char: Character) -> Bool {
    switch (char) {
    case "a", "A", "e", "E", "i", "I", "o", "O", "u", "U":
        return true
    default:
        return false
    }
}

func alternatingVowelsAndConsonants(word: String) -> Bool {
    return zip(word, word.dropFirst()).allSatisfy{isVowel($0.0) != isVowel($0.1)}
}

do {
    try String(contentsOfFile: "unixdict.txt", encoding: String.Encoding.ascii)
        .components(separatedBy: "\n")
        .filter{$0.count > 9 && alternatingVowelsAndConsonants(word: $0)}
        .enumerated()
        .forEach{print(String(format: "%2d. %@", $0.0 + 1, $0.1))}
} catch {
    print(error.localizedDescription)
}
