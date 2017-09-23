// version 1.1.2

fun main(Args: Array<String>) {
    print("Player 1 - Enter your name : ")
    val name1 = readLine()!!.trim().let { if (it == "") "PLAYER 1" else it.toUpperCase() }
    print("Player 2 - Enter your name : ")
    val name2 = readLine()!!.trim().let { if (it == "") "PLAYER 2" else it.toUpperCase() }
    val names = listOf(name1, name2)
    val r = java.util.Random()
    val totals = intArrayOf(0, 0)
    var player = 0
    while (true) {
        println("\n${names[player]}")
        println("  Your total score is currently ${totals[player]}")
        var score = 0
        while (true) {
            print("  Roll or Hold r/h : ")
            val rh = readLine()!![0].toLowerCase()
            if (rh == 'h') {
                totals[player] += score
                println("  Your total score is now ${totals[player]}")
                if (totals[player] >= 100) {
                    println("  So, ${names[player]}, YOU'VE WON!")
                    return
                }
                player = if (player == 0) 1 else 0
                break
            }
            if (rh != 'r') {
                println("    Must be 'r'or 'h', try again")
                continue
            }
            val dice = 1 + r.nextInt(6)
            println("    You have thrown a $dice")
            if (dice == 1) {
                println("    Sorry, your score for this round is now 0")
                println("  Your total score remains at ${totals[player]}")
                player = if (player == 0) 1 else 0
                break
            }
            score += dice
            println("    Your score for the round is now $score")
        }
    }
}
