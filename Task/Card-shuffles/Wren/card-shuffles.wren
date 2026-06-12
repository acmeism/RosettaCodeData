import "random" for Random

var r = Random.new()

var riffle = Fn.new { |deck, iterations|
    var pile = deck.toList
    for (i in 0...iterations) {
        var mid = (deck.count / 2).floor
        var tenpc = (mid / 10).floor
        // choose a random number within 10% of midpoint
        var cut = mid - tenpc + r.int(2 * tenpc + 1)
        // split deck into two at cut point
        var deck1 = pile.take(cut).toList
        var deck2 = pile.skip(cut).toList
        pile.clear()
        var fromTop = r.int(2) == 1 // choose to draw from top or bottom
        while (deck1.count > 0 && deck2.count > 0) {
            if (fromTop) {
                pile.add(deck1.removeAt(0))
                pile.add(deck2.removeAt(0))
            } else {
                pile.add(deck1.removeAt(-1))
                pile.add(deck2.removeAt(-1))
            }
        }
        // add any remaining cards to the pile and reverse it
        if (deck1.count > 0) {
            pile.addAll(deck1)
        } else if (deck2.count > 0) {
            pile.addAll(deck2)
        }
        pile = pile[-1..0] // as pile is upside down
    }
    return pile
}

var overhand = Fn.new { |deck, iterations|
    var pile = deck.toList
    var pile2 = []
    var twentypc = (deck.count / 5).floor
    for (i in 0...iterations) {
        while (pile.count > 0) {
            var cards = pile.count.min(1 + r.int(twentypc))
            pile2 = pile[0...cards] + pile2
            pile = pile[cards..-1]
        }
        pile.addAll(pile2)
        pile2.clear()
    }
    return pile
}

System.print("Starting deck:")
var deck = (1..20).toList
System.print(deck)
var iterations = 10
System.print("\nRiffle shuffle with %(iterations) iterations:")
System.print(riffle.call(deck, iterations))
System.print("\nOverhand shuffle with %(iterations) iterations:")
System.print(overhand.call(deck, iterations))
System.print("\nStandard library shuffle with 1 iteration:")
r.shuffle(deck) // shuffles deck in place
System.print(deck)
