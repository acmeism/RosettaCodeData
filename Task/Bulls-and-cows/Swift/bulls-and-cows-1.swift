func generateRandomNumArray(numDigits: Int = 4) -> [Character]
{
	guard (1 ... 9).contains(numDigits) else { fatalError("number out of range") }

	return Array("123456789".shuffled()[0 ..< numDigits])
}

func parseGuess(_ guess: String, numDigits: Int = 4) -> String?
{
	guard guess.count == numDigits else { return nil }
    // Only digits 0 to 9 allowed, no Unicode fractions or numbers from other languages
	let guessArray = guess.filter{ $0.isASCII && $0.isWholeNumber }

  	guard Set(guessArray).count == numDigits else { return nil }

  	return guessArray
}

func pluralIfNeeded(_ count: Int, _ units: String) -> String
{
	return "\(count) " + units + (count == 1 ? "" : "s")
}

var guessAgain = "y"
while guessAgain == "y"
{
  	let num = generateRandomNumArray()
  	var bulls = 0
  	var cows = 0

  	print("Please enter a 4 digit number with digits between 1-9, no repetitions: ")

  	if let guessStr = readLine(strippingNewline: true), let guess = parseGuess(guessStr)
	{
		for (guess, actual) in zip(guess, num)
		{
			if guess == actual
			{
	  			bulls += 1
			}
			else if num.contains(guess)
			{
	  			cows += 1
			}
  		}

		print("Actual number: " + num)
		print("Your score: \(pluralIfNeeded(bulls, "bull")) and \(pluralIfNeeded(cows, "cow"))\n")
		print("Would you like to play again? (y): ")

		guessAgain = readLine(strippingNewline: true)?.lowercased() ?? "n"
	}
	else
	{
		print("Invalid input")
  	}
}
