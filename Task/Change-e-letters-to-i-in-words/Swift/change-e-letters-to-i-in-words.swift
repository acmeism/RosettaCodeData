import Foundation

func loadDictionary(path: String, minLength: Int) throws -> Set<String> {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    return Set<String>(contents.components(separatedBy: "\n").filter{$0.count >= minLength})
}

func pad(string: String, width: Int) -> String {
    return string.count >= width ? string
        : string + String(repeating: " ", count: width - string.count)
}

do {
    let dictionary = try loadDictionary(path: "unixdict.txt", minLength: 6)
    var words: [(String,String)] = []
    for word1 in dictionary {
        let word2 = word1.replacingOccurrences(of: "e", with: "i")
        if word1 != word2 && dictionary.contains(word2) {
            words.append((word1, word2))
        }
    }
    words.sort(by: {$0 < $1})
    for (n, (word1, word2)) in words.enumerated() {
        print(String(format: "%2d. %@ -> %@", n + 1, pad(string: word1, width: 10), word2))
    }
} catch {
    print(error.localizedDescription)
}
