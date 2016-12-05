let string = "Hello, Swift language"
let (n, m) = (5, 4)

// Starting from `n` characters in and of `m` length.
do {
  let start = string.startIndex.advancedBy(n)
  let end = start.advancedBy(m)
  // Pure-Swift (standard library only):
  _ = string[start..<end]
  // With Apple's Foundation framework extensions:
  string.substringWithRange(start..<end)
}

// Starting from `n` characters in, up to the end of the string.
do {
  // Pure-Swift (standard library only):
  _ = String(
    string.characters.suffix(string.characters.count - n)
  )
  // With Apple's Foundation framework extensions:
  _ = string.substringFromIndex(string.startIndex.advancedBy(n))
}

// Whole string minus last character.
do {
  // Pure-Swift (standard library only):
  _ = String(
    string.characters.prefix(
      string.characters.count.predecessor()
    )
  )
  // With Apple's Foundation framework extensions:
  _ = string.substringToIndex(string.endIndex.predecessor())
}

// Starting from a known character within the string and of `m` length.
do {
  // Pure-Swift (standard library only):
  let character = Character("l")
  guard let characterIndex = string.characters.indexOf(character) else {
    fatalError("Index of '\(character)' character not found.")
  }
  let endIndex = characterIndex.advancedBy(m)
  _ = string[characterIndex..<endIndex]
}

// Starting from a known substring within the string and of `m` length.
do {
  // With Apple's Foundation framework extensions:
  let substring = "Swift"
  guard let range = string.rangeOfString(substring) else {
    fatalError("Range of substring \(substring) not found")
  }
  let start = range.startIndex
  let end = start.advancedBy(m)
  string[start..<end]
}
