import Foundation

func generateRandomNumArray(numDigits: Int = 4) -> [Int] {
  guard numDigits > 0 else {
    return []
  }

  let needed =  min(9, numDigits)
  var nums = Set<Int>()

  repeat {
    nums.insert(.random(in: 1...9))
  } while nums.count != needed

  return Array(nums)
}

func parseGuess(_ guess: String) -> [Int]? {
  guard guess.count == 4 else {
    return nil
  }

  let guessArray = guess.map(String.init).map(Int.init).compactMap({ $0 })

  guard Set(guessArray).count == 4 else {
    return nil
  }

  return guessArray
}

while true {
  let num = generateRandomNumArray()
  var bulls = 0
  var cows = 0

  print("Please enter a 4 digit number with digits between 1-9, no repetitions: ")

  guard let guessStr = readLine(strippingNewline: true), let guess = parseGuess(guessStr) else {
    print("Invalid input")
    continue
  }

  for (guess, actual) in zip(guess, num) {
    if guess == actual {
      bulls += 1
    } else if num.contains(guess) {
      cows += 1
    }
  }

  print("Actual number: \(num.map(String.init).joined())")
  print("Your score: \(bulls) bulls and \(cows) cows\n")
  print("Would you like to play again? (y): ")

  guard readLine(strippingNewline: true)!.lowercased() == "y" else {
    exit(0)
  }
}
