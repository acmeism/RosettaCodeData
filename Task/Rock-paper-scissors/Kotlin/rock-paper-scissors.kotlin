// version 1.2.10

import java.util.Random

const val choices = "rpsq"
val rand = Random()

var pWins = 0                  // player wins
var cWins = 0                  // computer wins
var draws = 0                  // neither wins
var games = 0                  // games played
val pFreqs = arrayOf(0, 0, 0)  // player frequencies for each choice (rps)

fun printScore() = println("Wins: You $pWins, Computer $cWins, Neither $draws\n")

fun getComputerChoice(): Char {
    // make a completely random choice until 3 games have been played
    if (games < 3) return choices[rand.nextInt(3)]
    val num = rand.nextInt(games)
    return when {
        num < pFreqs[0] -> 'p'
        num < pFreqs[0] + pFreqs[1] -> 's'
        else -> 'r'
    }
}

fun main(args: Array<String>) {
    println("Enter: (r)ock, (p)aper, (s)cissors or (q)uit\n")
    while (true) {
        printScore()
        var pChoice: Char
        while (true) {
            print("Your choice r/p/s/q : ")
            val input = readLine()!!.toLowerCase()
            if (input.length == 1) {
                pChoice = input[0]
                if (pChoice in choices) break
            }
            println("Invalid choice, try again")
        }
        if (pChoice == 'q') {
            println("OK, quitting")
            return
        }
        val cChoice = getComputerChoice()
        println("Computer's choice   : $cChoice")
        if (pChoice == 'r' && cChoice == 's') {
            println("Rock breaks scissors - You win!")
            pWins++
        }
        else if (pChoice == 'p' && cChoice == 'r') {
            println("Paper covers rock - You win!")
            pWins++
        }
        else if (pChoice == 's' && cChoice == 'p') {
            println("Scissors cut paper - You win!")
            pWins++
        }
        else if (pChoice == 's' && cChoice == 'r') {
            println("Rock breaks scissors - Computer wins!")
            cWins++
        }
        else if (pChoice == 'r' && cChoice == 'p') {
            println("Paper covers rock - Computer wins!")
            cWins++
        }
        else if (pChoice == 'p' && cChoice == 's') {
            println("Scissors cut paper - Computer wins!")
            cWins++
        }
        else {
            println("It's a draw!")
            draws++
        }
        pFreqs[choices.indexOf(pChoice)]++
        games++
        println()
    }
}
