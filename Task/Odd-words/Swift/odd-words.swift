import Foundation

let minLength = 5

func loadDictionary(_ path: String) throws -> Set<String> {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    return Set<String>(contents.components(separatedBy: "\n").filter{$0.count >= minLength})
}

func pad(string: String, width: Int) -> String {
    return string.count >= width ? string
        : string + String(repeating: " ", count: width - string.count)
}

func printWords(words: [(String,String)]) {
    for (n, (word1, word2)) in words.enumerated() {
        print("\(String(format: "%2d", n + 1)): \(pad(string: word1, width: 14))\(word2)")
    }
}

do {
    let dictionary = try loadDictionary("unixdict.txt")
    var oddWords: [(String, String)] = []
    var evenWords: [(String, String)] = []
    for word in dictionary {
        if word.count < minLength + 2*(minLength/2) {
            continue
        }
        var oddWord = ""
        var evenWord = ""
        for (i, c) in word.enumerated() {
            if (i & 1) == 0 {
                oddWord.append(c)
            } else {
                evenWord.append(c)
            }
        }
        if dictionary.contains(oddWord) {
            oddWords.append((word, oddWord))
        }
        if dictionary.contains(evenWord) {
            evenWords.append((word, evenWord))
        }
    }
    oddWords.sort(by: {$0.0 < $1.0})
    evenWords.sort(by: {$0.0 < $1.0})
    print("Odd words:")
    printWords(words: oddWords)
    print("\nEven words:")
    printWords(words: evenWords)
} catch {
    print(error.localizedDescription)
}
