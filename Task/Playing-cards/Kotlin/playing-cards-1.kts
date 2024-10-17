const val FACES = "23456789TJQKA"
const val SUITS = "shdc"

fun createDeck(): List<String> {
    val cards = mutableListOf<String>()
    FACES.forEach { face -> SUITS.forEach { suit -> cards.add("$face$suit") } }
    return cards
}

fun dealTopDeck(deck: List<String>, n: Int) = deck.take(n)

fun dealBottomDeck(deck: List<String>, n: Int) = deck.takeLast(n).reversed()

fun printDeck(deck: List<String>) {
    for (i in deck.indices) {
        print("${deck[i]}  ")
        if ((i + 1) % 13 == 0 || i == deck.size - 1) println()
    }
}

fun main(args: Array<String>) {
    var deck = createDeck()
    println("After creation, deck consists of:")
    printDeck(deck)
    deck = deck.shuffled()
    println("\nAfter shuffling, deck consists of:")
    printDeck(deck)
    val dealtTop = dealTopDeck(deck, 10)
    println("\nThe 10 cards dealt from the top of the deck are:")
    printDeck(dealtTop)
    val dealtBottom = dealBottomDeck(deck, 10)
    println("\nThe 10 cards dealt from the bottom of the deck are:")
    printDeck(dealtBottom)
}
