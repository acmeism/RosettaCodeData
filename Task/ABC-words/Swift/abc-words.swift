import Foundation

func loadDictionary(_ path: String) throws -> [String] {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    return contents.components(separatedBy: "\n")
}

func isAbcWord(_ word: String) -> Bool {
    var a = false
    var b = false
    for ch in word {
        switch (ch) {
        case "a":
            if !a {
                a = true
            }
        case "b":
            if !b {
                if !a {
                    return false
                }
                b = true
            }
        case "c":
            return b
        default:
            break
        }
    }
    return false
}

do {
    let dictionary = try loadDictionary("unixdict.txt")
    var n = 1
    for word in dictionary {
        if isAbcWord(word) {
            print("\(n): \(word)")
            n += 1
        }
    }
} catch {
    print(error)
}
