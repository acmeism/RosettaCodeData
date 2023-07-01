// version 1.1.3

import java.util.Collections.shuffle

enum class Color   { RED, GREEN, PURPLE }
enum class Symbol  { OVAL, SQUIGGLE, DIAMOND }
enum class Number  { ONE, TWO, THREE }
enum class Shading { SOLID, OPEN, STRIPED }
enum class Degree  { BASIC, ADVANCED }

class Card(
    val color:   Color,
    val symbol:  Symbol,
    val number:  Number,
    val shading: Shading
) : Comparable<Card> {

    private val value =
        color.ordinal * 27 + symbol.ordinal * 9 + number.ordinal * 3  + shading.ordinal

    override fun compareTo(other: Card) = value.compareTo(other.value)

    override fun toString() = (
        color.name.padEnd(8)   +
        symbol.name.padEnd(10) +
        number.name.padEnd(7)  +
        shading.name.padEnd(7)
    ).toLowerCase()

    companion object {
        val zero = Card(Color.RED, Symbol.OVAL, Number.ONE, Shading.SOLID)
    }
}

fun createDeck() =
    List<Card>(81) {
        val col = Color.values()  [it / 27]
        val sym = Symbol.values() [it / 9 % 3]
        val num = Number.values() [it / 3 % 3]
        val shd = Shading.values()[it % 3]
        Card(col, sym, num, shd)
    }

fun playGame(degree: Degree) {
    val deck = createDeck()
    val nCards = if (degree == Degree.BASIC) 9 else 12
    val nSets = nCards / 2
    val sets = Array(nSets) { Array(3) { Card.zero } }
    var hand: Array<Card>
    outer@ while (true) {
        shuffle(deck)
        hand = deck.take(nCards).toTypedArray()
        var count = 0
        for (i in 0 until hand.size - 2) {
            for (j in i + 1 until hand.size - 1) {
                for (k in j + 1 until hand.size) {
                    val trio = arrayOf(hand[i], hand[j], hand[k])
                    if (isSet(trio)) {
                        sets[count++] = trio
                        if (count == nSets) break@outer
                    }
                }
            }
        }
    }
    hand.sort()
    println("DEALT $nCards CARDS:\n")
    println(hand.joinToString("\n"))
    println("\nCONTAINING $nSets SETS:\n")
    for (s in sets) {
        s.sort()
        println(s.joinToString("\n"))
        println()
    }
}

fun isSet(trio: Array<Card>): Boolean {
    val r1 = trio.sumBy { it.color.ordinal   } % 3
    val r2 = trio.sumBy { it.symbol.ordinal  } % 3
    val r3 = trio.sumBy { it.number.ordinal  } % 3
    val r4 = trio.sumBy { it.shading.ordinal } % 3
    return (r1 + r2 + r3 + r4) == 0
}

fun main(args: Array<String>) {
    playGame(Degree.BASIC)
    println()
    playGame(Degree.ADVANCED)
}
