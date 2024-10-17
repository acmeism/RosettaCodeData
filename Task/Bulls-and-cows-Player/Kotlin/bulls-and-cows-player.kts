// version 1.1.2

import java.util.Random

fun countBullsAndCows(guess: IntArray, answer: IntArray): Pair<Int,Int> {
    var bulls = 0
    var cows = 0
    for ((i, d) in guess.withIndex()) {
        if (answer[i] == d) bulls++
        else if (d in answer) cows++
    }
    return bulls to cows
}

fun main(args: Array<String>) {
    val r = Random()
    val choices = mutableListOf<IntArray>()
    // generate all possible distinct 4 digit (1 to 9) integer arrays
    for (i in 1..9) {
        for (j in 1..9) {
            if (j == i) continue
            for (k in 1..9) {
                if (k == i || k == j) continue
                for (l in 1..9) {
                    if (l == i || l == j || l == k) continue
                    choices.add(intArrayOf(i, j, k, l))
                }
            }
        }
    }

    // pick one at random as the answer
    val answer = choices[r.nextInt(choices.size)]

    // keep guessing, pruning the list as we go based on the score, until answer found
    while (true) {
        val guess = choices[r.nextInt(choices.size)]
        val (bulls, cows) = countBullsAndCows(guess, answer)
        println("Guess = ${guess.joinToString("")}  Bulls = $bulls  Cows = $cows")
        if (bulls == 4) {
            println("You've just found the answer!")
            return
        }
        for (i in choices.size - 1 downTo 0) {
            val (bulls2, cows2) = countBullsAndCows(choices[i], answer)
            // if score is no better remove it from the list of choices
            if (bulls2 <= bulls && cows2 <= cows) choices.removeAt(i)
        }
        if (choices.size == 0)
            println("Something went wrong as no choices left! Aborting program")
    }
}
