import Foundation

func loadDictionary(_ path: String) throws -> Set<String> {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    return Set<String>(contents.components(separatedBy: "\n").filter{!$0.isEmpty})
}

func lpad(string: String, width: Int) -> String {
    return string.count >= width ? string
        : string + String(repeating: " ", count: width - string.count)
}

do {
    let dictionary = try loadDictionary("unixdict.txt")
    var alternades: [(String,String,String)] = []
    for word in dictionary {
        if word.count < 6 {
            continue
        }
        var word1 = ""
        var word2 = ""
        for (i, c) in word.enumerated() {
            if (i & 1) == 0 {
                word1.append(c)
            } else {
                word2.append(c)
            }
        }
        if dictionary.contains(word1) && dictionary.contains(word2) {
            alternades.append((word, word1, word2))
        }
    }
    alternades.sort(by: {$0.0 < $1.0})
    for (word, word1, word2) in alternades {
        print("\(lpad(string: word, width: 10))\(lpad(string: word1, width: 6))\(word2)")
    }
} catch {
    print(error.localizedDescription)
}
