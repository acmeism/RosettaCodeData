// version 1.1.51

import java.util.Random
import java.util.Collections.shuffle

val r = Random()

fun riffle(deck: List<Int>, iterations: Int): List<Int> {
    val pile = deck.toMutableList()

    repeat(iterations) {
        val mid = deck.size / 2
        val tenpc = mid / 10
        // choose a random number within 10% of midpoint
        val cut = mid - tenpc + r.nextInt(2 * tenpc + 1)
        // split deck into two at cut point
        val deck1 = pile.take(cut).toMutableList()
        val deck2 = pile.drop(cut).toMutableList()
        pile.clear()
        val fromTop = r.nextBoolean() // choose to draw from top or bottom
        while (deck1.size > 0 && deck2.size > 0) {
            if (fromTop) {
                pile.add(deck1.removeAt(0))
                pile.add(deck2.removeAt(0))
            }
            else {
                pile.add(deck1.removeAt(deck1.lastIndex))
                pile.add(deck2.removeAt(deck2.lastIndex))
            }
        }
        // add any remaining cards to the pile and reverse it
        if (deck1.size > 0) pile.addAll(deck1)
        else if (deck2.size > 0) pile.addAll(deck2)
        pile.reverse() // as pile is upside down
    }
    return pile
}

fun overhand(deck: List<Int>, iterations: Int): List<Int> {
    val pile = deck.toMutableList()
    val pile2 = mutableListOf<Int>()
    val twentypc = deck.size / 5
    repeat(iterations) {
        while (pile.size > 0) {
            val cards = minOf(pile.size, 1 + r.nextInt(twentypc))
            pile2.addAll(0, pile.take(cards))
            repeat(cards) { pile.removeAt(0) }
        }
        pile.addAll(pile2)
        pile2.clear()
    }
    return pile
}

fun main(args: Array<String>) {
    println("Starting deck:")
    var deck = List<Int>(20) { it + 1 }
    println(deck)
    val iterations = 10
    println("\nRiffle shuffle with $iterations iterations:")
    println(riffle(deck, iterations))
    println("\nOverhand shuffle with $iterations iterations:")
    println(overhand(deck, iterations))
    println("\nStandard library shuffle with 1 iteration:")
    shuffle(deck) // shuffles deck in place
    println(deck)
}
