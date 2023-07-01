func isPangram(str: String) -> Bool {
  let (char, alph) = (Set(str.characters), "abcdefghijklmnopqrstuvwxyz".characters)
  return !alph.contains {!char.contains($0)}
}
