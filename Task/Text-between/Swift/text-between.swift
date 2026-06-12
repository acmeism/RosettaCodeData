import Foundation

public extension String {
  func textBetween(_ startDelim: String, and endDelim: String) -> String {
    precondition(!startDelim.isEmpty && !endDelim.isEmpty)

    let startIdx: String.Index
    let endIdx: String.Index

    if startDelim == "start" {
      startIdx = startIndex
    } else if let r = range(of: startDelim) {
      startIdx = r.upperBound
    } else {
      return ""
    }

    if endDelim == "end" {
      endIdx = endIndex
    } else if let r = self[startIdx...].range(of: endDelim) {
      endIdx = r.lowerBound
    } else {
      endIdx = endIndex
    }

    return String(self[startIdx..<endIdx])
  }
}

let tests = [
  ("Hello Rosetta Code world", "Hello ", " world"),
  ("Hello Rosetta Code world", "start", " world"),
  ("Hello Rosetta Code world", "Hello ", "end"),
  ("</div><div style=\"chinese\">你好嗎</div>", "<div style=\"chinese\">", "</div>"),
  ("<text>Hello <span>Rosetta Code</span> world</text><table style=\"myTable\">", "<text>", "<table>"),
  ("<table style=\"myTable\"><tr><td>hello world</td></tr></table>", "<table>", "</table>"),
  ("The quick brown fox jumps over the lazy other fox", "quick ", " fox"),
  ("One fish two fish red fish blue fish", "fish ", " red"),
  ("FooBarBazFooBuxQuux", "Foo", "Foo")
]

for (input, start, end) in tests {
  print("Input: \"\(input)\"")
  print("Start delimiter: \"\(start)\"")
  print("End delimiter: \"\(end)\"")
  print("Text between: \"\(input.textBetween(start, and: end))\"\n")
}
