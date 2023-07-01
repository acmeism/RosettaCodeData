import Foundation

print("Input max number: ", terminator: "")

guard let maxN = Int(readLine() ?? "0"), maxN > 0 else {
  fatalError("Please input a number greater than 0")
}

func getFactor() -> (Int, String) {
  print("Enter a factor and phrase: ", terminator: "")

  guard let factor1Input = readLine() else {
    fatalError("Please enter a factor")
  }

  let sep1 = factor1Input.components(separatedBy: " ")
  let phrase = sep1.dropFirst().joined(separator: " ")

  guard let factor = Int(sep1[0]), factor != 0, !phrase.isEmpty else {
    fatalError("Please enter a factor and phrase")
  }

  return (factor, phrase)
}

let (factor1, phrase1) = getFactor()
let (factor2, phrase2) = getFactor()
let (factor3, phrase3) = getFactor()

for i in 1...maxN {
  let factors = [
    (i.isMultiple(of: factor1), phrase1),
    (i.isMultiple(of: factor2), phrase2),
    (i.isMultiple(of: factor3), phrase3)
  ].filter({ $0.0 }).map({ $0.1 }).joined()

  print("\(factors.isEmpty ? String(i) : factors)")
}
