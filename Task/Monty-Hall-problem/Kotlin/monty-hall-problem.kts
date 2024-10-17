// version 1.1.2

import java.util.Random

fun montyHall(games: Int) {
    var switchWins = 0
    var stayWins = 0
    val rnd = Random()
    (1..games).forEach {
        val doors = IntArray(3)        // all zero (goats) by default
        doors[rnd.nextInt(3)] = 1      // put car in a random door
        val choice = rnd.nextInt(3)    // choose a door at random
        var shown: Int
        do {
            shown = rnd.nextInt(3)     // the shown door
        }
        while (doors[shown] == 1 || shown == choice)
        stayWins += doors[choice]
        switchWins += doors[3 - choice - shown]
    }
    println("Simulating $games games:")
    println("Staying   wins $stayWins times")
    println("Switching wins $switchWins times")
}

fun main(args: Array<String>) {
    montyHall(1_000_000)
}
