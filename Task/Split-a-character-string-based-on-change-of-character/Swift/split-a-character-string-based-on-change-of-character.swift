public extension String {
  func splitOnChanges() -> [String] {
    guard !isEmpty else {
      return []
    }

    var res = [String]()
    var workingChar = first!
    var workingStr = "\(workingChar)"

    for char in dropFirst() {
      if char != workingChar {
        res.append(workingStr)
        workingStr = "\(char)"
        workingChar = char
      } else {
        workingStr += String(char)
      }
    }

    res.append(workingStr)

    return res
  }
}

print("gHHH5YY++///\\".splitOnChanges().joined(separator: ", "))
