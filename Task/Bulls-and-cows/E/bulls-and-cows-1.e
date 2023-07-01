def Digit := 1..9
def Number := Tuple[Digit,Digit,Digit,Digit]

/** Choose a random number to be guessed. */
def pick4(entropy) {
    def digits := [1,2,3,4,5,6,7,8,9].diverge()

    # Partial Fisher-Yates shuffle
    for i in 0..!4 {
        def other := entropy.nextInt(digits.size() - i) + i
        def t := digits[other]
        digits[other] := digits[i]
        digits[i] := t
    }
    return digits(0, 4)
}

/** Compute the score of a guess. */
def scoreGuess(actual :Number, guess :Number) {
    var bulls := 0
    var cows := 0
    for i => digit in guess {
        if (digit == actual[i]) {
            bulls += 1
        } else if (actual.indexOf1(digit) != -1) {
            cows += 1
        }
    }
    return [bulls, cows]
}

/** Parse a guess string into a list of digits (Number). */
def parseGuess(guessString, fail) :Number {
    if (guessString.size() != 4) {
        return fail(`I need four digits, not ${guessString.size()} digits.`)
    } else {
        var digits := []
        for c in guessString {
            if (('1'..'9')(c)) {
                digits with= c - '0'
            } else {
                return fail(`I need a digit from 1 to 9, not "$c".`)
            }
        }
        return digits
    }
}

/** The game loop: asking for guesses and reporting scores and win conditions.
    The return value is null or a broken reference if there was a problem. */
def bullsAndCows(askUserForGuess, tellUser, entropy) {
    def actual := pick4(entropy)

    def gameTurn() {
        return when (def guessString := askUserForGuess <- ()) -> {
            escape tellAndContinue {

                def guess := parseGuess(guessString, tellAndContinue)
                def [bulls, cows] := scoreGuess(actual, guess)

                if (bulls == 4) {
                    tellUser <- (`You got it! The number is $actual!`)
                    null
                } else {
                    tellAndContinue(`Your score for $guessString is $bulls bulls and $cows cows.`)
                }

            } catch message {
                # The parser or scorer has something to say, and the game continues afterward
                when (tellUser <- (message)) -> {
                    gameTurn()
                }
            }
        } catch p {
            # Unexpected problem of some sort
            tellUser <- ("Sorry, game crashed.")
            throw(p)
        }
    }

    return gameTurn()
}
