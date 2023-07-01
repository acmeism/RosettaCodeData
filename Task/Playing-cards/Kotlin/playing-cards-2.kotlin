class Deck : ArrayList<String> {
    constructor() { FACES.forEach { face -> SUITS.forEach { add("$face$it") } } }
    constructor(c: Collection<String>) { addAll(c) }

    fun dealTop(n: Int) = Deck(take(n))
    fun dealBottom(n: Int) = Deck(takeLast(n).reversed())

    fun print() {
        forEachIndexed { i, s ->
            print("$s  ")
            if ((i + 1) % 13 == 0 || i == size - 1) println()
        }
    }

    private companion object {
        const val FACES = "23456789TJQKA"
        const val SUITS = "shdc"
    }
}

fun main(args: Array<String>) {
    val deck = Deck()
    println("After creation, deck consists of:")
    deck.print()
    deck.shuffle()
    println("\nAfter shuffling, deck consists of:")
    deck.print()
    println("\nThe 10 cards dealt from the top of the deck are:")
    deck.dealTop(10).print()
    println("\nThe 10 cards dealt from the bottom of the deck are:")
    deck.dealBottom(10).print()
}
