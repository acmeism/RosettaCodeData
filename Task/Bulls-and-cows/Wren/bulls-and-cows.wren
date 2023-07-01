import "random" for Random
import "./set" for Set
import "./ioutil" for Input

var MAX_GUESSES = 20  // say
var r = Random.new()
var num
// generate a 4 digit random number from 1234 to 9876 with no zeros or repeated digits
while (true) {
    num = (1234 + r.int(8643)).toString
    if (!num.contains("0") && Set.new(num).count == 4) break
}

System.print("All guesses should have exactly 4 distinct digits excluding zero.")
System.print("Keep guessing until you guess the chosen number (maximum %(MAX_GUESSES) valid guesses).\n")
var guesses = 0
while (true) {
    var guess = Input.text("Enter your guess : ")
    if (guess == num) {
        System.print("You've won with %(guesses+1) valid guesses!")
        return
    }
    var n = Num.fromString(guess)
    if (!n) {
        System.print("Not a valid number")
    } else if (guess.contains("-") || guess.contains("+") || guess.contains(".")) {
        System.print("Can't contain a sign or decimal point")
    } else if (guess.contains("e") || guess.contains("E")) {
        System.print("Can't contain an exponent")
    } else if (guess.contains("0")) {
        System.print("Can't contain zero")
    } else if (guess.count != 4) {
        System.print("Must have exactly 4 digits")
    } else if (Set.new(guess).count < 4) {
        System.print("All digits must be distinct")
    } else {
        var bulls = 0
        var cows  = 0
        var i = 0
        for (c in guess) {
            if (num[i] == c) {
                bulls = bulls + 1
            } else if (num.contains(c)) {
                cows = cows + 1
            }
            i = i + 1
        }
        System.print("Your score for this guess:  Bulls = %(bulls)  Cows = %(cows)")
        guesses = guesses + 1
        if (guesses == MAX_GUESSES) {
            System.print("You've now had %(guesses) valid guesses, the maximum allowed")
            return
        }
    }
}
