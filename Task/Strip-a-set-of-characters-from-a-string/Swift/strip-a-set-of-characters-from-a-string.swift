extension String {
  func stripCharactersInSet(chars: [Character]) -> String {
    return String(seq: filter(self) {find(chars, $0) == nil})
  }
}

let aString = "She was a soul stripper. She took my heart!"
let chars: [Character] = ["a", "e", "i"]

println(aString.stripCharactersInSet(chars))
