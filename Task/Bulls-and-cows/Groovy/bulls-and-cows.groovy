class BullsAndCows {
    static void main(args) {
        def inputReader = System.in.newReader()
        def numberGenerator = new Random()
        def targetValue
        while (targetValueIsInvalid(targetValue = numberGenerator.nextInt(9000) + 1000)) continue
        def targetStr = targetValue.toString()
        def guessed = false
        def guesses = 0
        while (!guessed) {
            def bulls = 0, cows = 0
            print 'Guess a 4-digit number with no duplicate digits: '
            def guess = inputReader.readLine()
            if (guess.length() != 4 || !guess.isInteger() || targetValueIsInvalid(guess.toInteger())) {
                continue
            }
            guesses++
            4.times {
                if (targetStr[it] == guess[it]) {
                    bulls++
                } else if (targetStr.contains(guess[it])) {
                    cows++
                }
            }
            if (bulls == 4) {
                guessed = true
            } else {
                println "$cows Cows and $bulls Bulls."
            }
        }
        println "You won after $guesses guesses!"
    }

    static targetValueIsInvalid(value) {
        def digitList = []
        while (value > 0) {
            if (digitList[value % 10] == 0 || digitList[value % 10]) {
                return true
            }
            digitList[value % 10] = true
            value = value.intdiv(10)
        }
        false
    }
}
