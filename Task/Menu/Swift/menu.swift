func getMenuInput(selections: [String]) -> String {
  guard !selections.isEmpty else {
    return ""
  }

  func printMenu() {
    for (i, str) in selections.enumerated() {
      print("\(i + 1)) \(str)")
    }

    print("Selection: ", terminator: "")
  }

  while true {
    printMenu()

    guard let input = readLine(strippingNewline: true), !input.isEmpty else {
      return ""
    }

    guard let n = Int(input), n > 0, n <= selections.count else {
      continue
    }

    return selections[n - 1]
  }
}

let selected = getMenuInput(selections: [
  "fee fie",
  "huff and puff",
  "mirror mirror",
  "tick tock"
])

print("You chose: \(selected)")
