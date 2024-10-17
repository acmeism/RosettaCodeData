// version 1.1.2

class Card(val face: Int, val suit: Char)

const val FACES = "23456789tjqka"
const val SUITS = "shdc"

fun isStraight(cards: List<Card>): Boolean {
    val sorted = cards.sortedBy { it.face }
    if (sorted[0].face + 4 == sorted[4].face) return true
    if (sorted[4].face == 14 && sorted[0].face == 2 && sorted[3].face == 5) return true
    return false
}

fun isFlush(cards: List<Card>): Boolean {
    val suit = cards[0].suit
    if (cards.drop(1).all { it.suit == suit }) return true
    return false
}

fun analyzeHand(hand: String): String {
    val h = hand.toLowerCase()
    val split = h.split(' ').filterNot { it == "" }.distinct()
    if (split.size != 5) return "invalid"
    val cards = mutableListOf<Card>()

    for (s in split) {
        if (s.length != 2) return "invalid"
        val fIndex = FACES.indexOf(s[0])
        if (fIndex == -1) return "invalid"
        val sIndex = SUITS.indexOf(s[1])
        if (sIndex == -1) return "invalid"
        cards.add(Card(fIndex + 2, s[1]))
    }

    val groups = cards.groupBy { it.face }
    when (groups.size) {
        2 -> {
            if (groups.any { it.value.size == 4 }) return "four-of-a-kind"
            return "full-house"
        }
        3 -> {
            if (groups.any { it.value.size == 3 }) return "three-of-a-kind"
            return "two-pair"
        }
        4 -> return "one-pair"
        else -> {
            val flush = isFlush(cards)
            val straight = isStraight(cards)
            when {
                flush && straight -> return "straight-flush"
                flush             -> return "flush"
                straight          -> return "straight"
                else              -> return "high-card"
            }
        }
    }
}

fun main(args: Array<String>) {
    val hands = arrayOf(
        "2h 2d 2c kc qd",
        "2h 5h 7d 8c 9s",
        "ah 2d 3c 4c 5d",
        "2h 3h 2d 3c 3d",
        "2h 7h 2d 3c 3d",
        "2h 7h 7d 7c 7s",
        "th jh qh kh ah",
        "4h 4s ks 5d ts",
        "qc tc 7c 6c 4c",
        "ah ah 7c 6c 4c"
    )
    for (hand in hands) {
        println("$hand: ${analyzeHand(hand)}")
    }
}
