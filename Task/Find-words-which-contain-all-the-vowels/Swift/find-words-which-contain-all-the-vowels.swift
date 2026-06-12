import Foundation

func containsAllVowelsOnce(_ word: String) -> Bool {
    var vowels = 0
    for ch in word {
        var bit = 0
        switch (ch) {
        case "a", "A":
            bit = 1
        case "e", "E":
            bit = 2
        case "i", "I":
            bit = 4
        case "o", "O":
            bit = 8
        case "u", "U":
            bit = 16
        default:
            break
        }
        if bit == 0 {
            continue
        }
        if ((vowels & bit) != 0) {
            return false
        }
        vowels |= bit
    }
    return vowels == 31
}

do {
    try String(contentsOfFile: "unixdict.txt", encoding: String.Encoding.ascii)
        .components(separatedBy: "\n")
        .filter{$0.count > 10 && containsAllVowelsOnce($0)}
        .enumerated()
        .forEach{print(String(format: "%2d. %@", $0.0 + 1, $0.1))}
} catch {
    print(error.localizedDescription)
}
