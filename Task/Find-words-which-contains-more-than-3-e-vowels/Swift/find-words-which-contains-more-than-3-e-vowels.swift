import Foundation

func e3(_ word: String) -> Bool {
    var ecount = 0
    for ch in word {
        switch (ch) {
        case "a", "A", "i", "I", "o", "O", "u", "U":
            return false
        case "e", "E":
            ecount += 1
        default:
            break
        }
    }
    return ecount > 3
}

do {
    try String(contentsOfFile: "unixdict.txt", encoding: String.Encoding.ascii)
        .components(separatedBy: "\n")
        .filter{e3($0)}
        .enumerated()
        .forEach{print(String(format: "%2d. %@", $0.0 + 1, $0.1))}
} catch {
    print(error.localizedDescription)
}
