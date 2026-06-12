// Version 1.2.40

import java.util.Random

const val ESC = '\u001B'
const val TEST = true  // set to 'false' to erase each player's coins

fun getNumber(prompt: String, min: Int, max: Int, showMinMax: Boolean) : Int {
    var input: Int?
    do {
        print(prompt)
        if (showMinMax)
            print(" from $min to $max : ")
        else
            print(" : ")
        input = readLine()!!.toIntOrNull()
    }
    while (input == null || input !in min..max)
    println()
    return input
}

fun main(args: Array<String>) {
    val rand = Random()
    val players = getNumber("Number of players", 2, 9, true)
    val coins = getNumber("Number of coins per player", 3, 6, true)
    var remaining = MutableList(players) { it + 1 }
    var first = 1 + rand.nextInt(players)
    var round = 1
    println("The number of coins in your hand will be randomly determined for")
    println("each round and displayed to you. However, when you press ENTER")
    println("it will be erased so that the other players, who should look")
    println("away until it's their turn, won't see it. When asked to guess")
    println("the total, the computer won't allow a 'bum guess'.")
    while(true) {
        println("\nROUND $round:\n")
        var n = first
        val hands = IntArray(players + 1)
        val guesses = IntArray(players + 1) { -1 }
        do {
            println("  PLAYER $n:")
            println("    Please come to the computer and press ENTER")
            hands[n] = rand.nextInt(coins + 1)
            print("      <There are ${hands[n]} coin(s) in your hand>")
            do {} while (readLine() == null)
            if (!TEST) {
                print("${ESC}[1A")  // move cursor up one line
                print("${ESC}[2K")  // erase line
                println("\r")       // move cursor to beginning of line
            }
            else println()
            while (true) {
                val min = hands[n]
                val max = (remaining.size - 1) * coins + hands[n]
                val guess = getNumber("    Guess the total", min, max, false)
                if (guess !in guesses) {
                    guesses[n] = guess
                    break
                }
                println("    Already guessed by another player, try again")
            }
            val index = remaining.indexOf(n)
            n = if (index < remaining.lastIndex) remaining[index + 1]
                else remaining[0]
        }
        while (n != first)
        val total = hands.sum()
        println("  Total coins held = $total")
        var eliminated = false
        for (i in remaining) {
            if (guesses[i] == total) {
                println("  PLAYER $i guessed correctly and is eliminated")
                remaining.remove(i)
                eliminated = true
                break
            }
        }
        if (!eliminated)
            println("  No players guessed correctly in this round")
        else if (remaining.size == 1) {
            println("\nPLAYER ${remaining[0]} buys the drinks!")
            return
        }
        val index2 = remaining.indexOf(n)
        first = if (index2 < remaining.lastIndex) remaining[index2 + 1]
                else remaining[0]
        round++
    }
}
