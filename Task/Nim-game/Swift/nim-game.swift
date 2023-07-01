var tokens = 12

while tokens != 0 {
  print("Tokens remaining: \(tokens)\nPlease enter a number between 1 and 3: ", terminator: "")

  guard let input = readLine(), let n = Int(input), n >= 1 && n <= 3 else {
    fatalError("Invalid input")
  }

  tokens -= n

  if tokens == 0 {
    print("You win!")

    break
  }

  print("I'll remove \(4 - n) tokens.")

  tokens -= 4 - n

  if tokens == 0 {
    print("I win!")
  }

  print()
}
