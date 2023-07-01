import "/dynamic" for Tuple
import "/sort" for Sort
import "/seq" for Lst

var Card = Tuple.create("Card", ["face", "suit"])

var cmp = Fn.new { |i, j| (i.face - j.face).sign }

var isStraight = Fn.new { |cards, jokers|
    var sorted = Sort.merge(cards, cmp)
    if (jokers == 0) {
        if (sorted[0].face + 4 == sorted[4].face) return true
        if (sorted[4].face == 14 && sorted[3].face == 5) return true
        return false
    } else if (jokers == 1) {
        if (sorted[0].face + 3 == sorted[3].face) return true
        if (sorted[0].face + 4 == sorted[3].face) return true
        if (sorted[3].face == 14 && sorted[2].face == 4) return true
        if (sorted[3].face == 14 && sorted[2].face == 5) return true
        return false
    } else {
        if (sorted[0].face + 2 == sorted[2].face) return true
        if (sorted[0].face + 3 == sorted[2].face) return true
        if (sorted[0].face + 4 == sorted[2].face) return true
        if (sorted[2].face == 14 && sorted[1].face == 3) return true
        if (sorted[2].face == 14 && sorted[1].face == 4) return true
        if (sorted[2].face == 14 && sorted[1].face == 5) return true
        return false
    }
}

var isFlush = Fn.new { |cards|
    var sorted = Sort.merge(cards, cmp)
    var suit = sorted[0].suit
    if (sorted.skip(1).all { |card| card.suit == suit || card.suit == "j" }) return true
    return false
}

var analyzeHand = Fn.new { |hand|
    var split = Lst.distinct(hand.split(" ").where { |c| c != "" }.toList)
    if (split.count != 5) return "invalid"
    var cards = []
    var jokers = 0
    for (s in split) {
        if (s.bytes.count != 4) return "invalid"
        var cp = s.codePoints[0]
        var card =
             cp == 0x1f0a1 ? Card.new(14, "s") :
             cp == 0x1f0b1 ? Card.new(14, "h") :
             cp == 0x1f0c1 ? Card.new(14, "d") :
             cp == 0x1f0d1 ? Card.new(14, "c") :
             cp == 0x1f0cf ? Card.new(15, "j") : // black joker
             cp == 0x1f0df ? Card.new(16, "j") : // white joker
            (cp >= 0x1f0a2 && cp <= 0x1f0ab) ? Card.new(cp - 0x1f0a0, "s") :
            (cp >= 0x1f0ad && cp <= 0x1f0ae) ? Card.new(cp - 0x1f0a1, "s") :
            (cp >= 0x1f0b2 && cp <= 0x1f0bb) ? Card.new(cp - 0x1f0b0, "h") :
            (cp >= 0x1f0bd && cp <= 0x1f0be) ? Card.new(cp - 0x1f0b1, "h") :
            (cp >= 0x1f0c2 && cp <= 0x1f0cb) ? Card.new(cp - 0x1f0c0, "d") :
            (cp >= 0x1f0cd && cp <= 0x1f0ce) ? Card.new(cp - 0x1f0c1, "d") :
            (cp >= 0x1f0d2 && cp <= 0x1f0db) ? Card.new(cp - 0x1f0d0, "c") :
            (cp >= 0x1f0dd && cp <= 0x1f0de) ? Card.new(cp - 0x1f0d1, "c") :
                                               Card.new(0, "j") // invalid
        if (card.face == 0) return "invalid"
        if (card.suit == "j") jokers = jokers + 1
        cards.add(card)
    }
    var groups = Lst.groups(cards) { |card| card.face }
    if (groups.count == 2) {
        if (groups.any { |g| g[1].count == 4 }) {
            if (jokers == 0) return "four-of-a-kind"
            return "five-of-a-kind"
        }
        return "full-house"
    } else if (groups.count == 3) {
        if (groups.any { |g| g[1].count == 3 }) {
            if (jokers == 0) return "three-of-a-kind"
            if (jokers == 1) return "four-of-a-kind"
            return "five-of-a-kind"
        }
        return (jokers == 0) ? "two-pair" : "full-house"
    } else if (groups.count == 4) {
        if (jokers == 0) return "one-pair"
        if (jokers == 1) return "three-of-a-kind"
        return "four-of-a-kind"
    } else {
        var flush = isFlush.call(cards)
        var straight = isStraight.call(cards, jokers)
        if (flush && straight) return "straight-flush"
        if (flush)             return "flush"
        if (straight)          return "straight"
        return (jokers == 0) ? "high-card" : "one-pair"
    }
}

var hands = [
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
]
for (hand in hands) {
    System.print("%(hand): %(analyzeHand.call(hand))")
}
