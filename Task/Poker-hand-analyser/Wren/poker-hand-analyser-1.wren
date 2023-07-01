import "/dynamic" for Tuple
import "/sort" for Sort
import "/str" for Str
import "/seq" for Lst

var Card = Tuple.create("Card", ["face", "suit"])

var FACES = "23456789tjqka"
var SUITS = "shdc"

var isStraight = Fn.new { |cards|
    var cmp = Fn.new { |i, j| (i.face - j.face).sign }
    var sorted = Sort.merge(cards, cmp)
    if (sorted[0].face + 4 == sorted[4].face) return true
    if (sorted[4].face == 14 && sorted[0].face == 2 && sorted[3].face == 5) return true
    return false
}

var isFlush = Fn.new { |cards|
    var suit = cards[0].suit
    if (cards.skip(1).all { |card| card.suit == suit }) return true
    return false
}

var analyzeHand = Fn.new { |hand|
    var h = Str.lower(hand)
    var split = Lst.distinct(h.split(" ").where { |c| c != "" }.toList)
    if (split.count != 5) return "invalid"
    var cards = []
    for (s in split) {
        if (s.count != 2) return "invalid"
        var fIndex = FACES.indexOf(s[0])
        if (fIndex == -1) return "invalid"
        var sIndex = SUITS.indexOf(s[1])
        if (sIndex == -1) return "invalid"
        cards.add(Card.new(fIndex + 2, s[1]))
    }
    var groups = Lst.groups(cards) { |card| card.face }
    if (groups.count == 2) {
        if (groups.any { |g| g[1].count == 4 }) return "four-of-a-kind"
        return "full-house"
    } else if (groups.count == 3) {
        if (groups.any { |g| g[1].count == 3 }) return "three-of-a-kind"
        return "two-pair"
    } else if (groups.count == 4) {
        return "one-pair"
    } else {
        var flush = isFlush.call(cards)
        var straight = isStraight.call(cards)
        if (flush && straight) return "straight-flush"
        if (flush)             return "flush"
        if (straight)          return "straight"
        return "high-card"
    }
}

var hands = [
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
]
for (hand in hands) {
    System.print("%(hand): %(analyzeHand.call(hand))")
}
