extension String {
  func tokenize(separator: Character, escape: Character) -> [String] {
    var token = ""
    var tokens = [String]()
    var chars = makeIterator()

    while let char = chars.next() {
      switch char {
      case separator:
        tokens.append(token)
        token = ""
      case escape:
        if let next = chars.next() {
          token.append(next)
        }
      case _:
        token.append(char)
      }
    }

    tokens.append(token)

    return tokens
  }
}

print("one^|uno||three^^^^|four^^^|^cuatro|".tokenize(separator: "|", escape: "^"))
