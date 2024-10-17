// version 1.1.2

class Card(val face: Int, val suit: Char)

fun isStraight(cards: List<Card>, jokers: Int): Boolean {
    val sorted = cards.sortedBy { it.face }
    when (jokers) {
        0    -> {
            if (sorted[0].face + 4 == sorted[4].face) return true
            if (sorted[4].face == 14 && sorted[3].face == 5) return true
            return false
        }
        1    -> {
            if (sorted[0].face + 3 == sorted[3].face) return true
            if (sorted[0].face + 4 == sorted[3].face) return true
            if (sorted[3].face == 14 && sorted[2].face == 4) return true
            if (sorted[3].face == 14 && sorted[2].face == 5) return true
            return false
        }
        else -> {
            if (sorted[0].face + 2 == sorted[2].face) return true
            if (sorted[0].face + 3 == sorted[2].face) return true
            if (sorted[0].face + 4 == sorted[2].face) return true
            if (sorted[2].face == 14 && sorted[1].face == 3) return true
            if (sorted[2].face == 14 && sorted[1].face == 4) return true
            if (sorted[2].face == 14 && sorted[1].face == 5) return true
            return false
        }
    }
}

fun isFlush(cards: List<Card>): Boolean {
    val sorted = cards.sortedBy { it.face }
    val suit = sorted[0].suit
    if (sorted.drop(1).all { it.suit == suit || it.suit == 'j' }) return true
    return false
}

fun analyzeHand(hand: String): String {
    val split = hand.split(' ').filterNot { it == "" }.distinct()
    if (split.size != 5) return "invalid"
    val cards = mutableListOf<Card>()
    var jokers = 0
    for (s in split) {
        if (s.length != 2) return "invalid"
        val cp = s.codePointAt(0)
        val card = when (cp) {
             0x1f0a1 -> Card(14, 's')
             0x1f0b1 -> Card(14, 'h')
             0x1f0c1 -> Card(14, 'd')
             0x1f0d1 -> Card(14, 'c')
             0x1f0cf -> { jokers++; Card(15, 'j') }  // black joker
             0x1f0df -> { jokers++; Card(16, 'j') }  // white joker
             in 0x1f0a2..0x1f0ab -> Card(cp - 0x1f0a0, 's')
             in 0x1f0ad..0x1f0ae -> Card(cp - 0x1f0a1, 's')
             in 0x1f0b2..0x1f0bb -> Card(cp - 0x1f0b0, 'h')
             in 0x1f0bd..0x1f0be -> Card(cp - 0x1f0b1, 'h')
             in 0x1f0c2..0x1f0cb -> Card(cp - 0x1f0c0, 'd')
             in 0x1f0cd..0x1f0ce -> Card(cp - 0x1f0c1, 'd')
             in 0x1f0d2..0x1f0db -> Card(cp - 0x1f0d0, 'c')
             in 0x1f0dd..0x1f0de -> Card(cp - 0x1f0d1, 'c')
             else                -> Card(0, 'j') // invalid
        }
        if (card.face == 0) return "invalid"
        cards.add(card)
    }

    val groups = cards.groupBy { it.face }
    when (groups.size) {
        2 -> {
            if (groups.any { it.value.size == 4 }) {
                return when (jokers) {
                    0    -> "four-of-a-kind"
                    else -> "five-of-a-kind"
                }
            }
            return "full-house"
        }
        3 -> {
            if (groups.any { it.value.size == 3 }) {
                return when (jokers) {
                    0    -> "three-of-a-kind"
                    1    -> "four-of-a-kind"
                    else -> "five-of-a-kind"
                }
            }
            return if (jokers == 0) "two-pair" else "full-house"
        }
        4 -> return when (jokers) {
                    0    -> "one-pair"
                    1    -> "three-of-a-kind"
                    else -> "four-of-a-kind"
             }
        else -> {
            val flush = isFlush(cards)
            val straight = isStraight(cards,jokers)
            when {
                flush && straight -> return "straight-flush"
                flush             -> return "flush"
                straight          -> return "straight"
                else              -> return if (jokers == 0) "high-card" else "one-pair"
            }
        }
    }
}

fun main(args: Array<String>) {
    val hands = arrayOf(
        "🃏 🃂 🂢 🂮 🃍",
        "🃏 🂵 🃇 🂨 🃉",
        "🃏 🃂 🂣 🂤 🂥",
        "🃏 🂳 🃂 🂣 🃃",
        "🃏 🂷 🃂 🂣 🃃",
        "🃏 🂷 🃇 🂧 🃗",
        "🃏 🂻 🂽 🂾 🂱",
        "🃏 🃔 🃞 🃅 🂪",
        "🃏 🃞 🃗 🃖 🃔",
        "🃏 🃂 🃟 🂤 🂥",
        "🃏 🃍 🃟 🂡 🂪",
        "🃏 🃍 🃟 🃁 🃊",
        "🃏 🃂 🂢 🃟 🃍",
        "🃏 🃂 🂢 🃍 🃍",
        "🃂 🃞 🃍 🃁 🃊"
    )
    for (hand in hands) {
        println("$hand : ${analyzeHand(hand)}")
    }
}
