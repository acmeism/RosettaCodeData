// version 1.2.0

import java.util.Random

val rand = Random()

val snl = mapOf(
     4 to 14,  9 to 31, 17 to  7, 20 to 38, 28 to 84, 40 to 59, 51 to 67, 54 to 34,
    62 to 19, 63 to 81, 64 to 60, 71 to 91, 87 to 24, 93 to 73, 95 to 75, 99 to 78
)

val sixThrowsAgain = true

fun turn(player: Int, square: Int): Int {
    var square2 = square
    while (true) {
        val roll = 1 + rand.nextInt(6)
        print("Player $player, on square $square2, rolls a $roll")
        if (square2 + roll > 100) {
            println(" but cannot move.")
        }
        else {
            square2 += roll
            println(" and moves to square $square2.")
            if (square2 == 100) return 100
            val next = snl.getOrDefault(square2, square2)
            if (square2 < next) {
                println("Yay! Landed on a ladder. Climb up to $next.")
                if (next == 100) return 100
                square2 = next
            }
            else if (square2 > next) {
                println("Oops! Landed on a snake. Slither down to $next.")
                square2 = next
            }
        }
        if (roll < 6 || !sixThrowsAgain) return square2
        println("Rolled a 6 so roll again.")
    }
}

fun main(args: Array<String>) {
    // three players starting on square one
    val players = intArrayOf(1, 1, 1)
    while (true) {
        for ((i, s) in players.withIndex()) {
            val ns = turn(i + 1, s)
            if (ns == 100) {
                println("Player ${i+1} wins!")
                return
            }
            players[i] = ns
            println()
        }
    }
}
