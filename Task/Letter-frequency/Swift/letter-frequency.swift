import Foundation

let dictPath: String

switch CommandLine.arguments.count {
case 2:
  dictPath = CommandLine.arguments[1]
case _:
  dictPath = "/usr/share/dict/words"
}

let wordsData = FileManager.default.contents(atPath: dictPath)!
let allWords = String(data: wordsData, encoding: .utf8)!
let words = allWords.components(separatedBy: "\n")
let counts = words.flatMap({ $0.map({ ($0, 1) }) }).reduce(into: [:], { $0[$1.0, default: 0] += $1.1 })

for (char, count) in counts {
  print("\(char): \(count)")
}
