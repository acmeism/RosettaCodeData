import Foundation

func loadDictionary(_ path: String) throws -> Set<String> {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    return Set<String>(contents.components(separatedBy: "\n").filter{!$0.isEmpty})
}

func rotate<T>(_ array: inout [T]) {
    guard array.count > 1 else {
        return
    }
    let first = array[0]
    array.replaceSubrange(0..<array.count-1, with: array[1...])
    array[array.count - 1] = first
}

func findTeacupWords(_ dictionary: Set<String>) {
    var teacupWords: [String] = []
    var found = Set<String>()
    for word in dictionary {
        if word.count < 3 || found.contains(word) {
            continue
        }
        teacupWords.removeAll()
        var isTeacupWord = true
        var chars = Array(word)
        for _ in 1..<word.count {
            rotate(&chars)
            let w = String(chars)
            if (!dictionary.contains(w)) {
                isTeacupWord = false
                break
            }
            if w != word && !teacupWords.contains(w) {
                teacupWords.append(w)
            }
        }
        if !isTeacupWord || teacupWords.isEmpty {
            continue
        }
        print(word, terminator: "")
        found.insert(word)
        for w in teacupWords {
            found.insert(w)
            print(" \(w)", terminator: "")
        }
        print()
    }
}

do {
    let dictionary = try loadDictionary("unixdict.txt")
    findTeacupWords(dictionary)
} catch {
    print(error)
}
