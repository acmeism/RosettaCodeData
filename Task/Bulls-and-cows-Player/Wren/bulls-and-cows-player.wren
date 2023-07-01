import "random" for Random

var countBullsAndCows = Fn.new { |guess, answer|
    var bulls = 0
    var cows = 0
    var i = 0
    for (d in guess) {
        if (answer[i] == d) {
            bulls = bulls + 1
        } else if (answer.contains(d)) {
            cows = cows + 1
        }
        i = i + 1
    }
    return [bulls, cows]
}

var r = Random.new()
var choices = []
// generate all possible distinct 4 digit (1 to 9) integer arrays
for (i in 1..9) {
    for (j in 1..9) {
        if (j != i) {
            for (k in 1..9) {
                if (k != i &&  k != j) {
                    for (l in 1..9) {
                        if (l != i && l != j && l != k) {
                            choices.add([i, j, k, l])
                        }
                    }
                }
            }
        }
    }
}

// pick one at random as the answer
var answer = choices[r.int(choices.count)]

// keep guessing, pruning the list as we go based on the score, until answer found
while (true) {
    var guess = choices[r.int(choices.count)]
    var bc = countBullsAndCows.call(guess, answer)
    System.print("Guess = %(guess.join(""))  Bulls = %(bc[0])  Cows = %(bc[1])")
    if (bc[0] == 4) {
        System.print("You've just found the answer!")
        return
    }
    for (i in choices.count - 1..0) {
        var bc2 = countBullsAndCows.call(choices[i], answer)
        // if score is no better remove it from the list of choices
        if (bc2[0] <= bc[0] && bc2[1] <= bc[1]) choices.removeAt(i)
    }
    if (choices.count == 0) {
        System.print("Something went wrong as no choices left! Aborting program")
    }
}
