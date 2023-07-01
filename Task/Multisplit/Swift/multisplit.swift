extension String {
  func multiSplit(on seps: [String]) -> ([Substring], [(String, (start: String.Index, end: String.Index))]) {
    var matches = [Substring]()
    var matched = [(String, (String.Index, String.Index))]()
    var i = startIndex
    var lastMatch = startIndex

    main: while i != endIndex {
      for sep in seps where self[i...].hasPrefix(sep) {
        if i > lastMatch {
          matches.append(self[lastMatch..<i])
        } else {
          matches.append("")
        }

        lastMatch = index(i, offsetBy: sep.count)
        matched.append((sep, (i, lastMatch)))
        i = lastMatch

        continue main
      }

      i = index(i, offsetBy: 1)
    }

    if i > lastMatch {
      matches.append(self[lastMatch..<i])
    }

    return (matches, matched)
  }
}

let (matches, matchedSeps) = "a!===b=!=c".multiSplit(on: ["==", "!=", "="])

print(matches, matchedSeps.map({ $0.0 }))
