// version 1.2.10

import java.util.Random

val rand = Random()

val optimum = mapOf(
    "HHH" to "THH", "HHT" to "THH", "HTH" to "HHT", "HTT" to "HHT",
    "THH" to "TTH", "THT" to "TTH", "TTH" to "HTT", "TTT" to "HTT"
)

fun getUserSequence(): String {
    println("A sequence of three H or T should be entered")
    var userSeq: String
    do {
        print("Enter your sequence: ")
        userSeq = readLine()!!.toUpperCase()
    }
    while (userSeq.length != 3 || userSeq.any { it != 'H' && it != 'T' })
    return userSeq
}

fun getComputerSequence(userSeq: String = ""): String {
    val compSeq = if(userSeq == "")
        String(CharArray(3) { if (rand.nextInt(2) == 0) 'T' else 'H' })
    else
        optimum[userSeq]!!
    println("Computer's sequence: $compSeq")
    return compSeq
}

fun main(args: Array<String>) {
    var userSeq: String
    var compSeq: String
    val r = rand.nextInt(2)
    if (r == 0) {
        println("You go first")
        userSeq = getUserSequence()
        println()
        compSeq = getComputerSequence(userSeq)
    }
    else {
        println("Computer goes first")
        compSeq = getComputerSequence()
        println()
        userSeq = getUserSequence()
    }

    println()
    val coins = StringBuilder()
    while (true) {
        val coin = if (rand.nextInt(2) == 0) 'H' else 'T'
        coins.append(coin)
        println("Coins flipped: $coins")
        val len = coins.length
        if (len >= 3) {
            val seq = coins.substring(len - 3, len)
            if (seq == userSeq) {
                println("\nYou win!")
                return
            }
            else if (seq == compSeq) {
                println("\nComputer wins!")
                return
            }
        }
        Thread.sleep(2000) // wait two seconds for next flip
    }
}
