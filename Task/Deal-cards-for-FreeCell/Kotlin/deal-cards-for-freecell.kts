// version 1.1.3

class Lcg(val a: Long, val c: Long, val m: Long, val d: Long, val s: Long) {
    private var state = s

    fun nextInt(): Long {
        state = (a * state + c) % m
        return state / d
    }
}

const val CARDS  = "A23456789TJQK"
const val SUITS  = "♣♦♥♠"

fun deal(): Array<String?> {
    val cards = arrayOfNulls<String>(52)
    for (i in 0 until 52) {
       val card = CARDS[i / 4]
       val suit = SUITS[i % 4]
       cards[i] = "$card$suit"
    }
    return cards
}

fun game(n: Int) {
    require(n > 0)
    println("Game #$n:")
    val msc = Lcg(214013, 2531011, 1 shl 31, 1 shl 16, n.toLong())
    val cards = deal()
    for (m in 52 downTo 1) {
        val index = (msc.nextInt() % m).toInt()
        val temp = cards[index]
        cards[index] = cards[m - 1]
        print("$temp  ")
        if ((53 - m) % 8 == 0) println()
    }
    println("\n")
}

fun main(args: Array<String>) {
    game(1)
    game(617)
}
